Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbYGPOn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbYGPOn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbYGPOnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:43:49 -0400
Received: from mga12.intel.com ([143.182.124.36]:34029 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755130AbYGPOns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:43:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,373,1212390000"; 
   d="scan'208";a="21125449"
Date: Wed, 16 Jul 2008 10:37:18 -0400
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and
	x2apic support
Message-ID: <20080716143718.GA22500@ywang-dev>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710195320.GA23322@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710195320.GA23322@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 09:53:20PM +0200, Ingo Molnar wrote:
> 
> quite some stuff!
> 
> For review and testing purposes i've created a new topic branch for 
> this: tip/x86/x2apic and have picked up your patches into it.
> 
> I've pushed it out, but it's not merged into tip/master yet (obviously, 
> you sent this just a few minutes ago :)
> 
> It integrates fine with tip/master. If you do this:
> 
>   git-checkout tip/master
>   git-merge tip/x86/x2apic
> 
> you'll get a clean merge.
> 

I'm seeing the following build error using default config.

  AS      arch/x86/lib/csum-copy_64.o
arch/x86/lib/csum-copy_64.S: Assembler messages:
arch/x86/lib/csum-copy_64.S:48: Error: Macro `ignore' was already defined
make[1]: *** [arch/x86/lib/csum-copy_64.o] Error 1
make: *** [arch/x86/lib] Error 2
make: *** Waiting for unfinished jobs....

Anyone encountered the same problem or any idea of what's wrong?

Thanks
-Yong

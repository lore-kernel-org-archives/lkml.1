Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbYGPOx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbYGPOx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbYGPOxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:53:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52222 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbYGPOxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:53:18 -0400
Date: Wed, 16 Jul 2008 16:53:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and
	x2apic support
Message-ID: <20080716145301.GA10448@elte.hu>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710195320.GA23322@elte.hu> <20080716143718.GA22500@ywang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716143718.GA22500@ywang-dev>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yong Wang <yong.y.wang@linux.intel.com> wrote:

> On Thu, Jul 10, 2008 at 09:53:20PM +0200, Ingo Molnar wrote:
> > 
> > quite some stuff!
> > 
> > For review and testing purposes i've created a new topic branch for 
> > this: tip/x86/x2apic and have picked up your patches into it.
> > 
> > I've pushed it out, but it's not merged into tip/master yet (obviously, 
> > you sent this just a few minutes ago :)
> > 
> > It integrates fine with tip/master. If you do this:
> > 
> >   git-checkout tip/master
> >   git-merge tip/x86/x2apic
> > 
> > you'll get a clean merge.
> > 
> 
> I'm seeing the following build error using default config.
> 
>   AS      arch/x86/lib/csum-copy_64.o
> arch/x86/lib/csum-copy_64.S: Assembler messages:
> arch/x86/lib/csum-copy_64.S:48: Error: Macro `ignore' was already defined
> make[1]: *** [arch/x86/lib/csum-copy_64.o] Error 1
> make: *** [arch/x86/lib] Error 2
> make: *** Waiting for unfinished jobs....
> 
> Anyone encountered the same problem or any idea of what's wrong?

that should be fixed already.

What is the output of:

  git-log tip/master | head

? The latest should be:

  commit a328874646a654eabb67da88b3d0a606e552ffe7
  Merge: 760e48e... 9d3b08d...
  Author: Ingo Molnar <mingo@elte.hu>
  Date:   Tue Jul 15 17:16:40 2008 +0200

and there this error should not occur.

	Ingo

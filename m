Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbYDXH7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbYDXH7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 03:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYDXH66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 03:58:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:8102 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYDXH65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 03:58:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,703,1199692800"; 
   d="scan'208";a="274154883"
Subject: Re: [PATCH] PCI Express ASPM support should default to 'No'
From: Shaohua Li <shaohua.li@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <87abjjzo84.fsf@basil.nowhere.org>
References: <alpine.LNX.1.00.0804230024210.14359@dragon.funnycrock.com>
	 <200804221712.45972.jbarnes@virtuousgeek.org>
	 <1208912721.31625.3.camel@sli10-desk.sh.intel.com>
	 <87abjjzo84.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 16:02:06 +0800
Message-Id: <1209024126.7479.0.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-24 at 09:49 +0200, Andi Kleen wrote:
> Shaohua Li <shaohua.li@intel.com> writes:
> 
> > On Tue, 2008-04-22 at 17:12 -0700, Jesse Barnes wrote:
> >> On Tuesday, April 22, 2008 3:28 pm Jesper Juhl wrote:
> >> > Running 'make oldconfig' I just noticed that PCIEASPM defaults to
> >> > 'y' in Kconfig even though the feature is both experimental and the
> >> > help text recommends that if you are unsure you say 'n'.
> >> > It seems to me that this really should default to 'n', not 'y' at the
> >> > moment.
> >> > The following patch makes that change. Please consider applying.
> >> 
> >> Seem reasonable, Shaohua?  Please cc linux-pci on PCI patches
> >> though...
> > Ok, I'm fine with the patch. Though by default, the policy is to use
> > BIOS setting, that is if BIOS disables ASPM, we don't enable it too.
> 
> Once the feature is considered stable it would be nice to make it
> default y
> again. I think any power saving should be on by default (unless
> serious
> issues are known), not off.
yes, we could do it in next release.

Thanks,
Shaohua


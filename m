Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYDYBNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYDYBNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 21:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYDYBNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 21:13:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:11855 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbYDYBNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 21:13:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,706,1199692800"; 
   d="scan'208";a="237586690"
Subject: Re: [PATCH] PCI Express ASPM support should default to 'No'
From: Shaohua Li <shaohua.li@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <200804240833.19614.jbarnes@virtuousgeek.org>
References: <alpine.LNX.1.00.0804230024210.14359@dragon.funnycrock.com>
	 <87abjjzo84.fsf@basil.nowhere.org>
	 <1209024126.7479.0.camel@sli10-desk.sh.intel.com>
	 <200804240833.19614.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 09:16:21 +0800
Message-Id: <1209086181.1220.7.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-24 at 08:33 -0700, Jesse Barnes wrote:
> On Thursday, April 24, 2008 1:02 am Shaohua Li wrote:
> > On Thu, 2008-04-24 at 09:49 +0200, Andi Kleen wrote:
> > > Shaohua Li <shaohua.li@intel.com> writes:
> > > > Ok, I'm fine with the patch. Though by default, the policy is to use
> > > > BIOS setting, that is if BIOS disables ASPM, we don't enable it too.
> > >
> > > Once the feature is considered stable it would be nice to make it
> > > default y
> > > again. I think any power saving should be on by default (unless
> > > serious
> > > issues are known), not off.
> >
> > yes, we could do it in next release.
> 
> When we move to 'default y' we should also update the Kconfig text, removing 
> the experimental tag and changing the advice.
> 
> And yeah, I'd like to save power by default too, but do you think this has 
> seen enough test coverage to enable it by default?  Do we know of any 
> platforms where ASPM causes problems because the BIOS enabled it and we tried 
> to use it?
Some chipset or device don't implement ASPM well. It's said some e1000
card has the bug and maybe other devices. ASPM patch provided API to let
driver disable ASPM too, hopefully driver can start using it. The
default policy is using BIOS setting, so only when BIOS uses it we will
try to use it. At this point, we should be safe unless BIOS is broken.

Thanks,
Shaohua


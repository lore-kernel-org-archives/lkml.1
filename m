Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZDFU4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZDFU4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757475AbZDFU4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:56:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:54483 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562AbZDFU4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:56:30 -0400
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu)
 enabled
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Lutomirski <amluto@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Mark Gross <mgross@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090325175908.GA25518@elte.hu>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com>
	 <20090324203259.GC26930@elte.hu>
	 <1238003581.2085.53.camel@macbook.infradead.org>
	 <20090325175908.GA25518@elte.hu>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 13:56:01 -0700
Message-Id: <1239051362.22733.87.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 18:59 +0100, Ingo Molnar wrote:
> > > i have a Lenovo T500 that does not even boot with with DMAR enabled 
> > > in the BIOS (it's default-off), i get this panic in early bootup:
> > > 
> > >     DMAR hardware is malfunctioning
> > 
> > Can you show me the output of the pr_debug() statement at 
> > dmar.c:543 (in alloc_iommu()?
> 
> that's not easy - i use it right now :)
> 
> That's another reason why warnings and non-panic() behavior are 
> better for developers too. Had it not crashed i could have sent you 
> my dmesg and i would not have turned off DMAR in the BIOS.
> 
> Now it's turned off in my BIOS (first barrier) and i need to reboot 
> the kernel (second barrier) and i need to hack up a kernel in a 
> certain way to produce debug info (third barrier) - in the merge 
> window (fourth barrier ;-).

If you manage to get a chance to do this after the merge window closes,
that would be much appreciated.

I have a T400 now, which will help with certain things (at least I have
a machine on which I can test suspend/resume). But I don't think I can
reproduce your panic on it.

Dirk reported the same panic, but we've just turned his iommu back on
and completely failed to reproduce the problem -- so I'm kind of stuck.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


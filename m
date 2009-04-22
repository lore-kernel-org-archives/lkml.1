Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbZDVIQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbZDVIQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZDVIPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:15:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52236 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbZDVIPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:15:51 -0400
Date: Wed, 22 Apr 2009 10:14:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [patch] x64: fix FPU corruption with signals and
	preemption
Message-ID: <20090422081444.GB8562@elte.hu>
References: <1239315874.27006.8026.camel@localhost.localdomain> <20090421224951.GD24073@hera.kernel.org> <49EE4DE9.2070209@linux.intel.com> <20090421225912.GE3036@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421225912.GE3036@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> * H. Peter Anvin (hpa@linux.intel.com) wrote:
> > Chris Wright wrote:
> >>>
> >>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >>> Cc: stable@kernel.org			[2.6.28.x, 2.6.29.x]
> >>
> >> This one get lost?
> >
> > No, it's queued up in tip:x86/urgent and will be pushed upstream with  
> > the next push of x86 fixes to Linus.
> 
> OK, I had it marked as not upstream and not in tip, thanks for the 
> correction.

there was a bit of a patch delay with it. Since this is an old race 
leading back to ancient times, and because this is touching critical 
code, we kept it around some more before pushing it to Linus. The 
plan is for it to show up in -git in the next few days and then in 
-rc4.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbYGaV36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbYGaV36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYGaV3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:29:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43591 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbYGaV3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:29:49 -0400
Date: Thu, 31 Jul 2008 23:29:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
Message-ID: <20080731212915.GH2729@elte.hu>
References: <20080729172917.185593000@linux-os.sc.intel.com> <488FA318.3040905@zytor.com> <20080729232951.GB11223@linux-os.sc.intel.com> <488FAB2B.7050405@zytor.com> <20080730100326.GA9683@elte.hu> <20080730182539.GA17140@elte.hu> <20080730234102.GF11223@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730234102.GF11223@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Wed, Jul 30, 2008 at 11:25:39AM -0700, Ingo Molnar wrote:
> > I briefly merged it into tip/master to test it, but after about 10
> > randconfig iterations it ran into a spontaneous reboot crash. There's
> > nothing in the log, the box (an Athlon64 X2) just reboots spontaneously.
> > Removing the x86/xsave changes makes the system boot up fine.
> > 
> > I've pushed out the tree i tested into the tip/tmp.x86/xsave.broken
> > branch. The bad config is:
> > 
> >   http://redhat.com/~mingo/misc/config-Wed_Jul_30_20_09_12_CEST_2008.bad
> 
> Ingo, 2.6.25, 2.6.26 also reboots randomly with this config on my 
> dual-socket system.

hmmm ....

a few guesses: perhaps I2C related (the randconfig turned on I2C bits)? 
Do you have any way (hw test-kit) to figure out where the reboot comes 
from - is it a triple fault caused by the kernel? Or some hardware 
event?

	Ingo

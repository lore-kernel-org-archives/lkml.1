Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbXKBP3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbXKBP3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbXKBP3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:29:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59062 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbXKBP3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:29:01 -0400
Date: Fri, 2 Nov 2007 16:28:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Johannes Stezenbach <js@linuxtv.org>
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m &
	CONFIG_VIDEO_SAA7146_VV=y
Message-ID: <20071102152843.GA27674@elte.hu>
References: <20071026073736.GA24172@elte.hu> <Pine.LNX.4.58.0710310458150.19072@shell4.speakeasy.net> <20071101090142.GA13009@elte.hu> <Pine.LNX.4.58.0711010304490.18400@shell2.speakeasy.net> <20071101105738.GB28701@elte.hu> <Pine.LNX.4.58.0711011707550.18400@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0711011707550.18400@shell2.speakeasy.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Thu, 1 Nov 2007, Ingo Molnar wrote:
> > > For some time now I've thought the whole ttpci config/makefile setup
> > > sucked.  I've finally gone though and redone it and fixed this problem
> > > too.
> > >
> > > Here is the patch: http://linuxtv.org/hg/v4l-dvb/rev/5320c2571183
> >
> > the drivers/media/dvb/ttpci/Kconfig bits do not apply:
> >
> >  $ q push
> >  Applying patch patches/dvb-fix-5320c2571183.patch
> >  patching file drivers/media/common/Kconfig
> >  patching file drivers/media/dvb/ttpci/Kconfig
> >  Hunk #1 FAILED at 1.
> >  Hunk #2 FAILED at 63.
> >  Hunk #4 FAILED at 99.
> >  Hunk #5 FAILED at 120.
> >  Hunk #6 FAILED at 142.
> >  5 out of 6 hunks FAILED -- rejects in file
> >  drivers/media/dvb/ttpci/Kconfig
> >  patching file drivers/media/dvb/ttpci/Makefile
> >  Patch patches/dvb-fix-5320c2571183.patch does not apply (enforce with -f)
> >
> > got a link to the dependent patch that i'm apparently missing?
> 
> These two:
> http://linuxtv.org/hg/v4l-dvb/rev/5320c2571183
> http://linuxtv.org/hg/v4l-dvb/rev/64935a44e510

neither applies cleanly to current Linus -git.

	Ingo

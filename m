Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbYEGIf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbYEGIf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760771AbYEGIff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:35:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45858 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747AbYEGIfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:35:33 -0400
Date: Wed, 7 May 2008 10:35:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andreas Mohr <andi@lisas.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.26-rc1
Message-ID: <20080507083518.GA24701@elte.hu>
References: <8287f540805041818g534c4e02qaadb0e749c5f3439@mail.gmail.com> <20080505053935.GA15734@rhlx01.hs-esslingen.de> <20080505073030.GI3350@elte.hu> <Pine.LNX.4.64.0805051601280.3218@bombadil.infradead.org> <20080506130701.GB2146@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506130701.GB2146@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> >>>   LD      drivers/built-in.o
> >>> ld: drivers/media/built-in.o: No such file: No such file or directory
> >>> make[2]: *** [drivers/built-in.o] Error 1
> >>
> >> i reported and fixed that bug a week ago, see the "drivers/media build
> >> fix for modular builds" patch on lkml.
> >
> > Thanks for your good work!
> >
> > I got several of your patches, and applied them on my tree. Not sure 
> > if I got all ;)
> 
> i'm tracking these fixes (and a ton of other fixes) because it's 
> needed by our tests, so will let you know if there's anything missing 
> after the next video push+pull. Have a good second look at the Kconfig 
> patches i did - Kconfig dependencies are a maze to figure out and 
> debugging and sorting those out is not particularly straightforward to 
> someone like me who just wants to do a hit-and-run fix.

even with my full stack of fixes this fails with missing symbols:

  http://redhat.com/~mingo/misc/config-Wed_May__7_01_58_56_CEST_2008.bad

so please check this config too, whether your fixes covers that case as 
well.

	Ingo

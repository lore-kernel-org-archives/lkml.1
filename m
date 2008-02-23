Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbYBWLIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbYBWLIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYBWLII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:08:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40063 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbYBWLIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:08:07 -0500
Date: Sat, 23 Feb 2008 12:07:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Alexey Zaytsev <zaytsev.a@protei.ru>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Message-ID: <20080223110751.GN23833@elte.hu>
References: <47BEAF3B.3080809@protei.ru> <200802221513.58608.mb@bu3sch.de> <47BF101F.30301@protei.ru> <200802221848.37902.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802221848.37902.mb@bu3sch.de>
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


* Michael Buesch <mb@bu3sch.de> wrote:

> > If this is not a repgession, than I don't know what is. And if it is 
> > a regression, it should be fixed at least in the 2.6.24.y series, do 
> > you agree?
> 
> No. Playing with kconfig SELECT is really _nothing_ for a -stable 
> series. I am _not_ going to be responsible for any breakages. [...]

well, i've reviewed this thread and it's pretty apparent to any outside 
observer that you as a maintainer are ignoring Alexey Zaytsev's pretty 
reasonable request for a fix.

Alexey had a problem, he analyzed it, he found a fix which he tested, 
and he even has offered to test anything you send his way:

|| I have provided a patch that I believe is trivial, that I have tested 
|| with all possible config option combinations I thought were possible, 
|| and that fixes the regression. If you have a reason to believe it is 
|| wrong, please say it, I won't be offended. If there is a problem with 
|| the patch, I'll gladly fix and resend it.

that's about the most friendly tester attitude that is imaginable.

but what were you able to make out of that positive attitude? The only 
things i've seen you send his way were insults and general handwaving 
about how his patch breaks stuff (without providing a _shred_ of 
evidence).

I have to say, after having observed multiple incidents around b43 in 
the past few months you are one of the worst driver maintainers i've 
ever seen on lkml: you are ignoring regressions, you are frequently 
insulting our testers and now you even have the gall to NAK a patch to 
_your own buggy driver code_ without providing an alternative fix. 
Kudos.

	Ingo

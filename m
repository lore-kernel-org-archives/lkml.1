Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbZJLVNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbZJLVNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbZJLVNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:13:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35559 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758240AbZJLVNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:13:15 -0400
Date: Mon, 12 Oct 2009 23:12:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regressions] Re: kbuild: save ARCH & CROSS_COMPILE when
	building a kernel
Message-ID: <20091012211230.GC2797@elte.hu>
References: <20091003103441.GA10874@elte.hu> <20091004191729.GA20203@merkur.ravnborg.org> <20091009092648.GA18894@elte.hu> <20091011213546.GB2768@merkur.ravnborg.org> <20091012204402.GC17163@elte.hu> <20091012210804.GA4267@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012210804.GA4267@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > > 
> > > The patch in question is reverted in my next push to Linus.
> > 
> > Thanks! Mind sending the fix/revert here too, so that we can test 
> > whether that resolves all the problems?
> 
> Here it is.
> I intended to send it out before sending pull request to Linus but I forgot.
> 
> 	Sam
> 
> commit 2331d1a6cd3d6e580bc88b9a160066d9e1177fe1
> Author: Sam Ravnborg <sam@ravnborg.org>
> Date:   Sun Oct 11 23:22:58 2009 +0200
> 
>     kbuild: revert "save ARCH & CROSS_COMPILE ..."
>     
>     Revert commit 575543347b5baed0ca927cb90ba8807396fe9cc9
>     
>     It caused following issues:

Thanks Sam!!

	Ingo

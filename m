Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZLMMNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZLMMNj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 07:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZLMMNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 07:13:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47370 "HELO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752875AbZLMMNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 07:13:38 -0500
Date: Sun, 13 Dec 2009 13:13:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091213121321.GA20583@elte.hu>
References: <20091212101032.GB25286@elte.hu>
 <20091212023603.93768833.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
 <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain>
 <20091212214235.31429790@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain>
 <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain>
 <alpine.LFD.2.00.0912121513190.3535@localhost.localdomain>
 <20091213065844.GA20244@elte.hu>
 <20091213113626.7a854941@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091213113626.7a854941@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> >  earth4:~/tip> git checkout linus
> >  Date:   Fri Dec 11 20:58:20 2009 -0800
> >  earth4:~/tip> git grep -w unlock_kernel | wc -l
> >  841
> > 
> > we grew the (absolute) number of BKL sites by ~15%. Certainly the kernel grew 
> > at a much faster rate, so the relative proportion of the BKL shrunk.
> 
> Thats actually very misleading. [...]

Somewhat, so i qualified it with the next paragraph:

> > Also, a lot of BKL use was hidden before, and due to the BKL removal 
> > activities (by Thomas, Frederic, Jon, Alan and others) the remaining BKL 
> > using sites are a lot more well defined, a lot more isolated and thus a 
> > lot more removable than ever before.

Thanks,

	Ingo

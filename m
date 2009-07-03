Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbZGCQKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbZGCQKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbZGCQKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:10:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59587 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369AbZGCQKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:10:32 -0400
Date: Fri, 3 Jul 2009 18:10:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703161021.GA21399@elte.hu>
References: <20090703064518.GA30674@elte.hu> <20090703100834.6cb241b6@lxorguk.ukuu.org.uk> <20090703091655.GB3902@elte.hu> <20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk> <20090703095432.GC21141@elte.hu> <20090703110620.64fd1283@lxorguk.ukuu.org.uk> <20090703102234.GA32128@elte.hu> <20090703114431.37abd528@lxorguk.ukuu.org.uk> <20090703131727.GA3207@elte.hu> <20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> [...] Quite frankly the way some people behave with it is a 
> disgrace and it puts people off contributing to the kernel when 
> their 500 line driver gets nothing but emails from people saying 
> "that space is wrong". [...]

I'd like to address your generic argument here because i think it's 
interesting.

The thing is, IMO if the author or the affected maintainer(s) are 
not willing to do _basic_ cleanup of new drivers, they simply dont 
deserve more substantial review.

Why? Because their lack of basic care is a sign that they will 
likely be unwilling to expend the (far bigger) effort of actually do 
ongoing maintenance of the driver.

drivers/isdn/ is one example of unclean code, which, once it got 
upstream, never got cleaned up.

Its also a positive feedback loop: lack of basic cleanups deters 
contributors (for example i personally try to stay away from 'weird 
looking' code as 'not worth the effort'), which makes the code even 
worse ... which then bitrots as kernel facilities slowly change as 
the months go on.

So such unclean drivers you mention above should probably go to 
drivers/staging/ - that is an effort that tries to de-crappify 
drivers before they get mixed into core drivers.

All in one, i dont see at all the harm from people looking at 
stylistic issues first - it's an obvious first easy level of trust 
to inject into an unknown piece of code - if the reply to that 
minimal stylistic review is fixes then it makes sense to inject more 
effort into reviewing the driver. If the reply is defiance or 
inaction then the reviewer probably should not bother because nobody 
cares about his feedback.

Thanks,

	Ingo

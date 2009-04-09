Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbZDIFNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbZDIFNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZDIFNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:13:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39274 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbZDIFNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:13:43 -0400
Date: Thu, 9 Apr 2009 07:12:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 54/56] x86: Remove void casts
Message-ID: <20090409051236.GD5352@elte.hu>
References: <20090408140637.GC12931@elte.hu> <49DCB140.7000603@fastmail.fm> <20090408144055.GH12931@elte.hu> <49DCB8C5.4090108@fastmail.fm> <20090408144842.GK12931@elte.hu> <49DCBA61.8060507@fastmail.fm> <20090408145715.GO12931@elte.hu> <49DCBBDF.4040603@fastmail.fm> <20090408151644.GQ12931@elte.hu> <49DD0D02.3030604@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DD0D02.3030604@fastmail.fm>
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


* Jack Stone <jwjstone@fastmail.fm> wrote:

> Ingo Molnar wrote:
> > In theory we could put regex patterns into MAINTAINERS. Something 
> > like this:
> >
> > LOCKDEP AND LOCKSTAT
> > P:	Peter Zijlstra
> > M:	peterz@infradead.org
> > P:	Ingo Molnar
> > M:	mingo@redhat.com
> > L:	linux-kernel@vger.kernel.org
> > T:	git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git
> > F:	kernel/lock*
> > F:	include/linux/lockdep.h
> > S:	Maintained
> >
> > Note: there are files that fall under multiple maintainers so this 
> > wouldnt be a 'precise' thing - but it would sure be useful.
> >
> > ( There's also other details like subdirectories within a larger 
> >   hiearchy and there being overlap between problems. Sometimes they 
> >   are sub-maintained, sometimes they are exclusive so pure glob
> >   patterns are probably not enough. )
> >
> > If this concept looks good to you ... i'd suggest that before you do 
> > a large patch against MAINTAINERS mapping all the maintainer 
> > domains, could you just do it for a few cases and send an RFC patch 
> > to lkml?
> >
> > If there's a general upstream buy-in and a there's a 
> > scripts/list-maintainers.sh script that takes advantage of it then 
> > all this would be rather useful. (and i've Cc:-ed Andrew and Linus - 
> > if this is to be shot down due to fundamental objections then better 
> > do it at the early stages ;-)
> >
> > Plus checkpatch could be extended to check whether the Cc: list in a 
> > patch properly matches the patterns in MAINTAINERS.
> >
> > If done propery this would save us from quite a few mechanic "hm, 
> > who maintains _that_ file??" searches and it would also save 
> > maintainers from quite a few "hm, who queued up _that_ crap without 
> > Cc:-ing me??" moments.
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >   
> That has already been done. Someone just so happened to submit
> such a patch today.
> 
> http://marc.info/?l=linux-kernel&m=123916809504492&w=2

Ah, nice! I'll have a look.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbXG2AnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbXG2AnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 20:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbXG2AnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 20:43:14 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:53421 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324AbXG2AnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 20:43:13 -0400
Subject: Re: Linus 2.6.23-rc1
From: Kasper Sandberg <lkml@metanurb.dk>
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200707290141.19790.volker.armin.hemmann@tu-clausthal.de>
References: <200707290141.19790.volker.armin.hemmann@tu-clausthal.de>
Content-Type: text/plain; charset=ISO-8859-15
Date: Sun, 29 Jul 2007 02:40:31 +0200
Message-Id: <1185669631.1432.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-29 at 01:41 +0200, Volker Armin Hemmann wrote:
> Hi,
> 
> I never tried Con's patchset, for two reasons:
> I tried his 2.4 patches ones, and I never saw any improvements. So when people 
> were reporting huge improvements with his SD scheduler, I compared that with 
> the reports of huge improvements with his 2.4 kernel patches.

Well thats a reason if there ever were one...

> ...
> The second: too many patches. I only would have tried one or two, but the 
> ck-patchset is a lot bigger.. and I am a little bit uneasy about that.

so use only the scheduler? nobody forces you to do many things..

> 
> But I tried a lot of Ingo's cfs patches - and it was a very pleasant 
> experience. Ingo reacted very fast on my feedback and when I hit a problem he 
> really tried to find the cause and solve it - and it always was one patch, so 
> I felt a lot less scared ;)
> 
> My usual workload is very 'usual'. KDE desktop, kmail, konqueror, sometimes 
> xine or amarok providing some background noise while typing away in kate, 
> triplea, wesnoth or some other game when I need to 'rest' for a while. A lot 
> of compiling in the background, because I am one of these gentoo users.
> 
> With cfs the experience was much more pleasant than with the 'old' scheduler. 
> Compiling did not hurt as much as usual anymore - the only thing that hurts 
> is swap.... 
> 
> But there is another thing I do regularly: I play ut2004. Not every single 
> day, but sometimes several times a day. 20minutes of mayhem and then back to 
> the desktop.
> 
> And I do not see any problems with cfs and ut2004. The maximum FPS are indeed 
> a little bit lower (and you can argue that this really is not important if 
> the pre-game FPS in a level looking down on the floor go down from 390 to 
> 380FPS), but the minimum FPS went up!

well, surely CFS is better than the old vanilla scheduler, also with 3d,
and if you have that high fps, i doubt you will notice the effects me
and others are having. it is not that it is bad, its just not as good as
SD has shown to be possible..

> 
> In scenes when my system is fighting hard to provide the FPS, when the action 
> is high (like when fighting with half a douzend bots at a power node, while 
> some other bots are shooting into the mess) CFS is much better than the old 
> scheduler. It is a big difference if you get 6-10FPS or 15-25.
> (I am playing with maximum 'beautifullness' - I would be able to get a lot 
> more FPS, if I wanted, but I want a nice scenery and maximum visual 
> effects ...)
> 
> From my point of view 3D is a lot better with cfs. 

Better than old vanilla yes, but than SD? well, you should give it a
try.

> 
> Now the question for all the people who are bashing cfs for its bad 3d 
> performance: what am I doing wrong?

As said, we never said CFS was worse than old vanilla, and we never said
it was BAD, we did however say its not as good as SD :)

> 
> Glück Auf,
> Volker
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


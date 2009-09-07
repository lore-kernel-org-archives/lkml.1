Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbZIGLDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbZIGLDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 07:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZIGLDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 07:03:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49520 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZIGLDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 07:03:13 -0400
Date: Mon, 7 Sep 2009 13:03:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       utx@penguin.cz
Subject: Re: Zaurus suspend saga
Message-ID: <20090907110307.GK23450@elf.ucw.cz>
References: <20090906052653.GB1324@ucw.cz> <1252276145.17852.15.camel@dax.rpnet.com> <f17812d70909061806y651c390w1faa5364f0fb6ddc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70909061806y651c390w1faa5364f0fb6ddc@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I'd hate to see c) happen but I doubt I'm going to find time to rewrite
> > that code any time soon and nobody else even seems to have grasped how
> > deep this problem really is :(.
> 
> Yeah, I'd agree that to rebuild the charger code on top of SPI, and possibly
> as individual driver in the resume process (so order can be arranged) might
> be the final solution, however, that's not an easy job indeed.

Yep, zaurus is currently pretty broken; I don't think charging from
Linux works at all, so I simply power down back to bootloader for
charge.

Anyway, suspend/resume is currently more important for me than charge,
and I'd like to get at least that to work.

Could we apply the trivial patch from "zaurus c3000 aka spitz: fix
resume" , and preferably push it to linus for 2.6.31? One version
where kernel suspends/resumes would be good. 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

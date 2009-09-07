Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbZIGLlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbZIGLlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 07:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZIGLlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 07:41:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60910 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZIGLle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 07:41:34 -0400
Date: Mon, 7 Sep 2009 13:39:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: zaurus c3000 aka spitz: fix resume
Message-ID: <20090907113945.GN23450@elf.ucw.cz>
References: <20090906052840.GF1324@ucw.cz> <1252243938.4136.26.camel@utx.utx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252243938.4136.26.camel@utx.utx.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > sharpsl_pm.c code tries to read battery state very early during
> > resume, but those battery meters are connected on SPI and that's only
> > resumed way later.
> > 
> > Replace the check with simple checking of battery fatal signal, that
> > actually works at this stage.
> 
> Tested on:
> - SL-C3200
> - snapshot e07cccf4046978df10f2e13fe2b99b2f9b3a65db
> - Reverted: 15bce40cb3133bcc07d548013df97e4653d363c1 (manual merge)
> - Applied your patch.
> - Config is here:
>   http://www.penguin.cz/~utx/zaurus/feed/images/spitz/config-2.6.31-rc9-spitz
> 
> Here is a big progress:
> - Zaurus goes from resume.

Ouch, it seems Eric Miao's emails are currently bouncing :-(.
									Pavel
This is an automatically generated Delivery Status Notification.

Delivery to the following recipients failed.

       ymiao3@marvell.com

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

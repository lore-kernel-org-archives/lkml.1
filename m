Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbZHIKyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbZHIKyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 06:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbZHIKyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 06:54:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34573 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZHIKyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 06:54:40 -0400
Date: Sun, 9 Aug 2009 12:54:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@sirena.org.uk>
Cc: dtor@mail.ru, linux-input@vger.kernel.org, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@Opfer-Online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       utx@penguin.cz
Subject: Re: ads7846: clean up, fix pressure reporting
Message-ID: <20090809105434.GB746@elf.ucw.cz>
References: <20090807180941.GF1728@ucw.cz> <20090809105112.GD4773@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090809105112.GD4773@sirena.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-08-09 11:51:13, Mark Brown wrote:
> On Fri, Aug 07, 2009 at 08:09:41PM +0200, Pavel Machek wrote:
> 
> > +#ifndef VERBOSE
> > +#undef dev_dbg
> > +#define dev_dbg(...) do {} while(0)
> > +#endif
> 
> Better to convert the offending dev_dbg()s to dev_vdbg() instead, I'd
> have thought.

Ok, yes, I could do that, but... I believe current patch is already
better than what is there and modifying patch on zaurus is quite
painful...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

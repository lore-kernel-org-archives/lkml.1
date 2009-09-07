Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbZIGWcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbZIGWcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 18:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZIGWcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 18:32:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41712 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZIGWcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 18:32:13 -0400
Date: Tue, 8 Sep 2009 00:32:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Stanislav Brabec <utx@penguin.cz>, thommycheck@gmail.com,
       Russell King <rmk@arm.linux.org.uk>, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
       eric.miao@marvell.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: zaurus c3000 aka spitz: fix resume
Message-ID: <20090907223208.GC695@elf.ucw.cz>
References: <20090906052840.GF1324@ucw.cz> <1252243938.4136.26.camel@utx.utx.cz> <f17812d70909070908l26541562iec36a117c155aa08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70909070908l26541562iec36a117c155aa08@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-08 00:08:13, Eric Miao wrote:
> On Sun, Sep 6, 2009 at 9:32 PM, Stanislav Brabec<utx@penguin.cz> wrote:
> > Pavel Machek wrote:
> >> sharpsl_pm.c code tries to read battery state very early during
> >> resume, but those battery meters are connected on SPI and that's only
> >> resumed way later.
> >>
> >> Replace the check with simple checking of battery fatal signal, that
> >> actually works at this stage.
> >
> > Tested on:
> 
> Applied to 'fix'.

Thanks. Is there still chance to push it to 2.6.31? That would help a
lot. Alternatively, we could push it to the -stable tree at least...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

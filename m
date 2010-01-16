Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817Ab0APWPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0APWPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 17:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489Ab0APWPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 17:15:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54540 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab0APWPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 17:15:08 -0500
Date: Sat, 16 Jan 2010 23:14:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bart?omiej Zimo? <uzi18@o2.pl>, Andy Walls <awalls@radix.net>,
       Daniel Borkmann <danborkmann@googlemail.com>,
       linux-kernel@vger.kernel.org, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: Re: [suspend/resume] Re: userspace notification from module
Message-ID: <20100116221454.GA8425@elf.ucw.cz>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl>
 <201001152314.30355.rjw@sisk.pl>
 <20100116181211.GA1603@ucw.cz>
 <201001162307.48085.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001162307.48085.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Agreed, but so what? On PC, machine would power off at that
> > point. That would surprise the apps, too.
> > 
> > Basically new enough userland should not make battery run low enough
> > for either emergency power off or emergency suspend.
> 
> I wonder how it is supposed to achieve that without knowing the current battery
> status.  Do you mean it should poll the battery driver?

That's besides point, is it?

Usual kernel<->user interfaces should apply here. Zaurus provides
/proc/apm emulation, and I'm writing drivers/power/ driver. Not sure
it has event interface...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

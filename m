Return-Path: <linux-kernel-owner+w=401wt.eu-S1423175AbXEEJQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423175AbXEEJQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 05:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423189AbXEEJQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 05:16:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56097 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423179AbXEEJQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 05:16:54 -0400
Date: Sat, 5 May 2007 11:16:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Indan Zupancic <indan@nul.nu>
Cc: Oliver Neukum <oliver@neukum.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070505091643.GA25704@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704272107.28565.oliver@neukum.org> <84144f020704280222s42ff99ddg3eea3cb353c8882e@mail.gmail.com> <200704281537.53479.oliver@neukum.org> <20070503120637.GA3866@ucw.cz> <3052.81.207.0.53.1178315528.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3052.81.207.0.53.1178315528.squirrel@secure.samage.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> But the same functionality can be achieved by doing:
> 
> 1) Define a user password (e.g. /etc/shadow thing). (Once)
> 
> 2) When a user logs in: get random data and encrypt it with the password,
> this becomes the AES key. Store both the data and key in a secure way in
> memory, e.g. using the existing kernel key infrastructure.



> Advantage of this scheme is that it only need AES and can be done (mostly)
> in kernel space. It's also faster and simpler than the current RSA scheme.
> Disadvantage is that it wastes at least 32 bytes of memory when the system
> is running, to store the data and key.

Another disadvantage is that you need to hack into PAM infrastructure,
that your suspend password needs to be same as someone's login
password, and that it will really only work with single-user machine.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

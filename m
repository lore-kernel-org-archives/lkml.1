Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbXKWLjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbXKWLjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 06:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbXKWLj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 06:39:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:57845 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbXKWLj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 06:39:26 -0500
Message-ID: <4746BBC5.4000008@anagramm.de>
Date: Fri, 23 Nov 2007 12:38:45 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: devzero@web.de
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       Simon Arlott <simon@fire.lp0.eu>
Subject: OT: Re: System reboot triggered by just reading a device file....!?
References: <1761125@web.de>
In-Reply-To: <1761125@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX18jPIJ3LcP3Z07rUJeg8Koe3uQP33s2wgKll8d
 3+C7ARoNg/4YOd0mas0XQiJ2sM1qmbh9an2OTXsDxNlqTbLXnI
 sZWi5cxgaKe0OYdlxReBA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Roland!

Please don't top-post.

devzero@web.de schrieb:
 > > [was: it would be easy to disable the kernel watchdog]
 > thanks, but i know i could do this.

Good. I was also curious and just checked again. The watchdog subsystem
is by default _disabled_ in the kernel configuration. If you use some
distro's kernel, where they turned it on, complain to them!
If you turned it on yourself, you are really on your own...
the Kconfig help there is IMO sufficient and very clear and,
"If unsure, say N". Hmm... sorry?!

 > this thread is not meant to protect myself from this curiousity but it is meant
 > to protect others. it`s a trap.

I guess I understand your position. But I don't see no way to improve
the kernel in that point.
Complain to the guys who enabled the watchdog / setup this trap for
any reason.

 > i stepped into that.
 > now i know that trap, so i can easily sidestep.
 > it maybe very seldom that someone steps into this.
 > but it may happen and then someone will have trouble and spend time on this.
 > i think every admin can tell you about weird random reboots of his systems
 > which he cannot explain what was the reason for it.

That's one possible way of "learning by doing suicide (tm);"

 > this maybe some of those reasons and this one could be avoided.
 > i`m thinking of something simple like echo "now you`re armed" > /dev/watchdog

Read some details about watchdogs to get more background and why the
watchdog is triggered so easily and why it's good this way.
i.e: http://www.ganssle.com/watchdogs.pdf

Regards,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com



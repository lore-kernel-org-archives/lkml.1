Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbXGOLtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbXGOLtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 07:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbXGOLte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 07:49:34 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:46134 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758541AbXGOLte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 07:49:34 -0400
Message-ID: <469A09C9.6000608@arcor.de>
Date: Sun, 15 Jul 2007 13:49:29 +0200
From: Timo Lindemann <tlindemann@arcor.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070616)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: PROBLEM: kernel hang in ohci init
References: <4695EC25.6050003@arcor.de>	 <a781481a0707122015q48fd8a06m5d0e54b109708757@mail.gmail.com>	 <200707122040.36800.david-b@pacbell.net> <4699F9CB.5010407@arcor.de>	 <a781481a0707150418o35e4d60fs59cba3f835ebef67@mail.gmail.com> <a781481a0707150429y22b8b10bv413f5f6ba498d3e4@mail.gmail.com>
In-Reply-To: <a781481a0707150429y22b8b10bv413f5f6ba498d3e4@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To sum this up:

the userspace 2.6.20.6 (the "good" kernel) and 2.6.22 (the "bad" kernel)
were compiled in is exactly the same setup. I recompiled "good" to check
for that, earlier, but "good" also works then.

"good" does not exhibit the printks I placed in the section (the same
ones I did for "bad"), making it plausible that the section is not
executed at all.

dmesg is not captured to disk, netconsole and serial console also do not
work (they both did in the "good" kernel). Also, my keyboard does not
work with "bad" during that phase -- Magic SysRq is also not working then.

I can try to hook up the laptop to an external monitor to capture some
more dmesg, and just shoot a photo, but I am right now trying to work
with git, as Satyam suggested.

Thanks very much for reading and helping :-)

Regards,
TL

-- 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbXJTJ36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbXJTJ36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 05:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbXJTJ3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 05:29:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2146 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752646AbXJTJ3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 05:29:48 -0400
Date: Thu, 18 Oct 2007 19:52:02 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "legolas558@users.sourceforge.net" <legolas558@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Laptop keyboard unusable when ACPI is active was Re: [2.6.22] i8042, ACPI, ipw2100 and issues reported by psmouse.c atkbd.c
Message-ID: <20071018195202.GA6962@ucw.cz>
References: <47001841.1000107@users.sourceforge.net> <470DD906.9090504@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470DD906.9090504@users.sourceforge.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> legolas558@users.sourceforge.net ha scritto:
> > Kernel: 2.6.22-r5
> > Kernel option: i8042.nomux=1
> I am now using kernel 2.6.22-r8 (Gentoo) and the following kernel options:
> 
> i8042.nomux=1 acpi=off
> 
> I have tried kernel 2.6.23-rc9 but the problem is still there.

Try usb keyboard.

Are you experiencing unusually high latencies in acpi mode?

Any unusual activity on top?

Try disabling lm_sensors.

Try disabling acpi embedded controller.

Is it smp box?

Try watching keyboard interrupts. Are they lost?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764149AbXJTSdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764149AbXJTSdR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 14:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbXJTSdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 14:33:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:55798 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbXJTSdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 14:33:05 -0400
Date: Sat, 20 Oct 2007 20:33:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "legolas558@users.sourceforge.net" <legolas558@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Laptop keyboard unusable when ACPI is active was Re: [2.6.22]
	i8042, ACPI, ipw2100 and issues reported by psmouse.c atkbd.c
Message-ID: <20071020183309.GB11373@elf.ucw.cz>
References: <47001841.1000107@users.sourceforge.net> <470DD906.9090504@users.sourceforge.net> <20071018195202.GA6962@ucw.cz> <4719EAEB.6060703@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4719EAEB.6060703@users.sourceforge.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Try disabling acpi embedded controller.
> >   
> How can I accomplish this? Are you referring to the i8042?

rmmod acpi_ec or how is it called. But I'm not sure how easy this is.

> > Try watching keyboard interrupts. Are they lost?
> >   
> I am pretty sure they are. I think that ACPI pauses interrupts for a
> while (100ms?) and so some keyboard interrupts are lost.

input layer can poll keyboard on its own, perhaps that helps?

Can you try to measure the interrupt latencies?

Does this happen in init=/bin/bash?
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

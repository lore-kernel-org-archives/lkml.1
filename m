Return-Path: <linux-kernel-owner+w=401wt.eu-S1946079AbXBBVeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946079AbXBBVeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 16:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946097AbXBBVeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 16:34:15 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49412 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946079AbXBBVeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 16:34:14 -0500
Date: Fri, 2 Feb 2007 22:13:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Leo Yuriev <ly@hanoi.cronyx.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.19 + VIA EPIA = very mysterious RESET-problem :(
Message-ID: <20070202211340.GA4737@elf.ucw.cz>
References: <1833199799.20070129203818@hanoi.cronyx.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1833199799.20070129203818@hanoi.cronyx.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I have a really big trouble with VIA-EPIA mainboards under Linux
> 2.6.19. After loading kernel Linux the RESET-circuit ceases to work
> correctly.
> 
> At reset (by RESET-button or by Watchdog) the system begins to be
> restarted, but hangs before occurrence of any BIOS-messages. Only a
> power-off and then power-up can help. The problem has been reproduced
> confidently and constantly, I has checked up about 20 mainboards (EPIA-
> EN/C7 and EPIA-PD/C3).
> 
> I am sure, this is not a Linux-related problem, but error in hardware
> design or BIOS-code. Because RESET-circuit must work always and be
> independent from a running software.

BIOS/hw problem.

> VIA's support doesn't give any usable response. But now I just need
> some workaround...
> 
> Does somebody has ideas?
> I can make some tests or perform deep-debugging, but currently I don't
> know where I could start from.

Try disabling acpi, apic, and/or try repeating it with minimum drivers.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

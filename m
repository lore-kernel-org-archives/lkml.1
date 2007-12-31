Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbXLaMXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbXLaMXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 07:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758034AbXLaMXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 07:23:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:60017 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962AbXLaMXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 07:23:24 -0500
Date: Mon, 31 Dec 2007 13:21:00 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071231132054.GB26339@ucw.cz>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <4777BDA5.4050203@keyaccess.nl> <alpine.LFD.1.00.0712301009220.32517@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0712301009220.32517@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > rene@7ixe4:~/src/port80$ su -c ./port80
> > cycles: out 2400, in 2401
> > rene@7ixe4:~/src/port80$ su -c ./port3cc
> > cycles: out 459, in 394
> > 
> > As stated a few dozen times by now already, port 0x80 is _decidedly_ _non_
> > _random_
> 
> Oh, I agree 100% that port 80 is not random. It's very much selected on 
> purpose.
> 
> The reason we use port 80 is because it's commonly used as the BIOS POST 
> debug port, which means that it's been a reasonable "safe" port to use, 
> since nobody would be so crazy as to actually hook up a real device behind 
> that port (and since it is below 0x100, it's also part of the "motherboard 
> range", so you won't have any crazy plug-in devices either).

Eh?

I have two mainboards here that have debug displays hooked to port
0x80. I have PCI DEBUG card that has display on port 0x80.

"You plug in PCI DEBUG card and it overclocks your machine" is bad
scenario.. (I don't know if it does... can PCI card emulate ISA timings?)
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

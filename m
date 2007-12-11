Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbXLKTgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbXLKTgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXLKTgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:36:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34681 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751332AbXLKTgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:36:24 -0500
Date: Tue, 11 Dec 2007 20:36:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "David P. Reed" <dpreed@reed.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rene Herman <rene.herman@keyaccess.nl>, Paul Rolland <rol@as2917.net>,
       David Newall <david@davidnewall.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
	with MCP51 laptops
Message-ID: <20071211193654.GE3437@elf.ucw.cz>
References: <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <20071211143224.15900995@tux.DEF.witbe.net> <475E9B9B.2050709@keyaccess.nl> <475EACB8.7080608@keyaccess.nl> <20071211163706.2dc82275@tux.DEF.witbe.net> <475EB263.2050405@keyaccess.nl> <475EC1C0.2040000@reed.com> <20071211173231.2b87a81f@the-village.bc.nu> <475EE2CA.6020601@reed.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475EE2CA.6020601@reed.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> a spec sheet, or even better a machine.   I may have an original PC-XT 
> still lying around in the attic, don't know if I can fire it up, but it had 
> such graphics cards.  I also have several early high-speed clones that were 
> "overclocked".

PC-XT does not count ... it needs to be 386 capable to
count... Hmm.. but we have ucLinux now, so maybe PC-XT does count.

>> Which requires care. Have you verified all the main chipset vendors ?
>>
>>   
> I obviously have not.   Clearly the guys who want this port 80 hack so 
> desperately have not either.  That's why we are in this pickle.

Noone _wants_ this port 0x80 hack. We already have it, had it for 10+
years, and now we are trying to get rid of it -- _safely_.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

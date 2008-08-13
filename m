Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbYHMUyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbYHMUyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYHMUyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:54:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50912 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYHMUyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:54:03 -0400
Date: Wed, 13 Aug 2008 22:55:19 +0200
From: Pavel Machek <pavel@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
Message-ID: <20080813205519.GF8861@elf.ucw.cz>
References: <20080806090246.GA1572@elf.ucw.cz> <87bq046cht.fsf@basil.nowhere.org> <20080812094135.GA1565@elf.ucw.cz> <20080812105409.GA1366@one.firstfloor.org> <48A16EFC.1050401@redhat.com> <20080812112602.GA2948@elf.ucw.cz> <20080813201359.GA27546@khazad-dum.debian.net> <20080813202801.GC8861@elf.ucw.cz> <20080813204242.GC27546@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813204242.GC27546@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > thinkpad-acpi will regard 128 and -128 as invalid sensors, because that's
> > > how they are used in some BIOSes (and ECs).  We used to bother only with
> > > -128, but Lenovo did something wierd in one of the EC firmwares and I had to
> > > add +128 too.  That masks the "help, I am melting" reading.
> > 
> > It was simpler than that. I did not pass "fan_control=1" option.
> > 
> > (Actually... I do not think that option is needed. If fan control is
> > known to work, it should be just enabled...)
> 
> I require explicit user permission to activate knobs that are that
> dangerous, and actively frowned upon by the manufacturer.

Well, it is not more dangerous than 2.6.26.2 (will overheat your
thinkpad, causing critical shutdown). Plus, acpi fans are
controllable/overridable by default from /proc, and 'echo "level 7" >
fan' is not something you can do accidentally...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

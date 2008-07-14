Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbYGNGOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbYGNGOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 02:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYGNGNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 02:13:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35396 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbYGNGNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 02:13:53 -0400
Date: Mon, 14 Jul 2008 08:14:30 +0200
From: Pavel Machek <pavel@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andy Lutomirski <luto@myrealbox.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Message-ID: <20080714061429.GF20258@elf.ucw.cz>
References: <200807122253.32382.rjw@sisk.pl> <48793A0E.3050803@myrealbox.com> <200807130133.12324.rjw@sisk.pl> <20080713091524.GA29907@elte.hu> <20080713120253.GA27582@srcf.ucam.org> <487A2431.2050103@myrealbox.com> <487A4CB7.1080001@firstfloor.org> <487A62B3.8010207@zytor.com> <487A63D2.9040006@firstfloor.org> <20080714012206.GA11882@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714012206.GA11882@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-07-13 22:22:06, Henrique de Moraes Holschuh wrote:
> On Sun, 13 Jul 2008, Andi Kleen wrote:
> > It probably switches to protected mode. I noticed this on my old
> > Fujitsu laptop when I tried to make the S3 wakeup run in the s2ram x86 emulator
> > and found it entered protected mode at some point, which x86emu
> > didn't support.
> > 
> > I guess Lenovo is doing the same.
> > 
> > And that protected mode code relies on some GDT values that have been
> > loaded earlier when the BIOS also went into protected mode.
> > 
> > It seems the BIOS programmers really don't like real mode anymore.
> > Somehow understandable.
> 
> If it were just Lenovo, it shouldn't be too difficult to get them to fix the
> BIOS.  But since other vendors have the same problem, that won't fly as a
> solution.

With all the BIOSes in field, practically impossible to update? (My
x60 has no CDrom..) No, I don't think we can expect fix from BIOS vendors.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

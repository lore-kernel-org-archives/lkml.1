Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbYHMU05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbYHMU05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYHMU0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:26:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36233 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbYHMU0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:26:46 -0400
Date: Wed, 13 Aug 2008 22:28:01 +0200
From: Pavel Machek <pavel@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
Message-ID: <20080813202801.GC8861@elf.ucw.cz>
References: <20080806090246.GA1572@elf.ucw.cz> <87bq046cht.fsf@basil.nowhere.org> <20080812094135.GA1565@elf.ucw.cz> <20080812105409.GA1366@one.firstfloor.org> <48A16EFC.1050401@redhat.com> <20080812112602.GA2948@elf.ucw.cz> <20080813201359.GA27546@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813201359.GA27546@khazad-dum.debian.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-08-13 17:13:59, Henrique de Moraes Holschuh wrote:
> On Tue, 12 Aug 2008, Pavel Machek wrote:
> > > Now, the CPU cores remains on 1.67GHz and fan is unable to cool them properly
> > > under heavy load (even if I set "level disengaged" through thinkpad fan control,
> > > temperature sensor shows after a while 128 C (probably not real temp,
> > > I expect some critical flag => and it properly switch off the
> > > system...)
> > 
> > How do you control fans? I could not get anything but -EINVAL from IBM
> > ACPI driver :-(.
> 
> thinkpad-acpi will regard 128 and -128 as invalid sensors, because that's
> how they are used in some BIOSes (and ECs).  We used to bother only with
> -128, but Lenovo did something wierd in one of the EC firmwares and I had to
> add +128 too.  That masks the "help, I am melting" reading.

It was simpler than that. I did not pass "fan_control=1" option.

(Actually... I do not think that option is needed. If fan control is
known to work, it should be just enabled...)
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

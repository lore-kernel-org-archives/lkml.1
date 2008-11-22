Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYKVMW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYKVMW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 07:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbYKVMWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 07:22:18 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48484 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757505AbYKVMWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 07:22:17 -0500
Date: Sat, 22 Nov 2008 13:21:50 +0100
From: Pavel Machek <pavel@suse.cz>
To: ?ric Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       trenn@suse.de, rpurdie@rpsys.net, hmh@hmh.eng.br
Subject: Re: HP accelerometer: split chip handling from HP ACPI interface
Message-ID: <20081122122149.GA1794@ucw.cz>
References: <20081121212121.GA7222@elf.ucw.cz> <20081121160022.86020953.akpm@linux-foundation.org> <49275194.6070604@tremplin-utc.net> <492757A8.6010509@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <492757A8.6010509@tremplin-utc.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-11-22 01:51:52, ?ric Piel wrote:
> Éric Piel schreef:
> > Andrew Morton schreef:
> >> On Fri, 21 Nov 2008 22:21:21 +0100
> >> Pavel Machek <pavel@suse.cz> wrote:
> >>
> >>> This patch splits handling between chip-specific lis3lv02d and HP/ACPI
> >>> specific hp_accel.c.
> >> umm, so?  What reason does anyone have for applying it?
> > Here is the log I have for the (old version) of pavel's patch:
> > 
> > The sensor can be accessed via various buses. In particular, SPI, I?C
> > and, on HP laptops, via a specific ACPI API (the only one currently
> > supported). Separate this latest platform from the core of the sensor
> > driver to allow support for the other bus type. The second, and more
> > direct goal is actually to be able to merge this part with the
> > hp-disk-leds driver, which has the same ACPI PNP number.
> > 
> > 
> > I'll try to follow with a patch doing the merge of the hp-disk-leds
> > driver, so that everything makes sense...
>
> Actually, I mistook, Pavel also included some led stuff in this patch.
> That doesn't look right, especially as the led driver is not
>removed!

I was simply planning to remove the LED stuff in the followup patch. I
guess I should have mentioned that in the changelog...

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

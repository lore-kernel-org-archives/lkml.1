Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbYJ0JFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbYJ0JFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYJ0JFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:05:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35702 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751937AbYJ0JFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:05:04 -0400
Date: Sun, 26 Oct 2008 18:40:25 +0100
From: Pavel Machek <pavel@suse.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Thomas Renninger <trenn@suse.de>, akpm@linux-foundation.org,
       burman.yan@gmail.com, rpurdie@rpsys.net,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>
Subject: Re: leds-hp-disk vs lis3lv02d
Message-ID: <20081026174023.GA1847@ucw.cz>
References: <200810162255.m9GMtKj4001733@imap1.linux-foundation.org> <200810192106.15905.trenn@suse.de> <20081019204819.GC1465@ucw.cz> <4902F817.4050108@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4902F817.4050108@tremplin-utc.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> shouldn't this one be integrated into Eric's/Yan's driver?
> > 
> > It is separate piece of hardware, completely unrelated to lids3v
> > chip. No, it should not be integrated, but I'll makesure they work
> > toggether well.
> Hello,
> I think I talked too fast: it seems impossible to have both drivers
> (leds-hp-disk and lis3lv02d) working at the same time. Only the first
> driver loaded is used.
> 
> After a little look at it, I think it comes from the fact that both
> drivers are assigned to the same MODALIAS (HPQ0004). The ACPI PNP
> (through the generic bus infrastructure) only declare the device to one
> of the drivers supporting it, not all of them.

I can reproduce it here and it obviously needs fixing. OTOH  it should
not block merge; both drivers still work and are useful.

> How can I tell to ACPI that it should load both drivers for the same PNP
> ID match?

I'll take a look if I can figure something out...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

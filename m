Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbZAVWRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbZAVWRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZAVWRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:17:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43146 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbZAVWRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:17:24 -0500
Date: Thu, 22 Jan 2009 23:17:08 +0100
From: Pavel Machek <pavel@suse.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HP accelerometer driver: testers wanted
Message-ID: <20090122221708.GA3430@elf.ucw.cz>
References: <20090122213139.GD2159@elf.ucw.cz> <200901222301.57681.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901222301.57681.elendil@planet.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-01-22 23:01:57, Frans Pop wrote:
> Hi Pavel,
> 
> Pavel Machek wrote:
> > It is in latest -mm. Enable CONFIG_SENSORS_LIS3LV02D,
> > recompile/reboot. Documentation is in Documentation/hwmon/lis3lv02d
> > and Documentation/hwmon/hpfall.c is standalone binary that should park
> > your disk (and light a led) as soon as freefall is detected.
> 
> My HP 2510p notebook has the device. By chance I activated the driver with 
> my last few builds and at least the input device works perfectly with 
> the -rc2 kernel (tested with jstest and Tux Racer).
> 
> What are the differences relative to -rc2? Looks like it adds the freefall 
> device?

Yes.

> Could you please give some additional info what exactly you want tested, 
> how to test it, and how safe it is to do the test?

Run hpfall, and see if LED lights and disk parks if you "drop" a
computer. (*)

> I'd be willing to test, but not if to do so I'd have to throw the notebook 
> out of the window... Or even if there is the slightest risk of somehow 
> damaging the hard disk.

(*) drop: just move it quickly downwards for 5-10cm. Even walking with
the computer usually triggers it for me.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

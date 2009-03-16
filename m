Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbZCPV2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbZCPV2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbZCPV1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:27:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52549 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZCPV1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:27:52 -0400
Date: Mon, 16 Mar 2009 22:30:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Mack <daniel@caiaq.de>, vbotka@suse.cz, mmarek@suse.cz
Cc: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] lis3: solve dependency between core and ACPI
Message-ID: <20090316213036.GB12308@elf.ucw.cz>
References: <49ABB22F.7040508@tremplin-utc.net> <1236004310-29196-1-git-send-email-daniel@caiaq.de> <1236004310-29196-2-git-send-email-daniel@caiaq.de> <1236004310-29196-3-git-send-email-daniel@caiaq.de> <1236004310-29196-4-git-send-email-daniel@caiaq.de> <49AD8B0A.90901@tremplin-utc.net> <20090304014350.GC5165@buzzloop.caiaq.de> <20090316190954.GK16052@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316190954.GK16052@buzzloop.caiaq.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > This solves the dependency between lis3lv02d.[ch] and ACPI specific
> > > > methods. It introduces a ->bus_priv pointer to the device struct which
> > > > is casted to 'struct acpi_device' in the ACIP layer. Changed hp_accel.c
> > > > accordingly.
> > > > 
> > > > This also moves the read_8() and read_16() routines from hp_accel.c to
> > > > lis3lv02d.c as they are not specific to ACPI.
> > > Hello,
> > > I've tried the patch series on my laptop. This particular patch burst
> > > the driver... need some work :-) The values are not read correctly and
> > > the IRQ is not detected. See down in the code...
> > 
> > Ok, obvious fixes. I'll post a new set of the three topmost patches -
> > could you test them again, please?
> 
> Could anyone test that on hardware which has a lis3 chip? I'd like to
> avoid missing the next merge window for this :)

I no longer have the hardware, Vlado has some. As does HP :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

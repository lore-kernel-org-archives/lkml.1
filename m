Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZHaJCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZHaJCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 05:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZHaJCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 05:02:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51259 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbZHaJCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 05:02:16 -0400
Date: Mon, 31 Aug 2009 11:02:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH V5 1/2] introduce ALS sysfs class
Message-ID: <20090831090207.GD11117@elf.ucw.cz>
References: <1251706028.3483.160.camel@rzhang-dt> <20090831083449.GB11117@elf.ucw.cz> <1251708537.3483.191.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251708537.3483.191.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-08-31 16:48:57, Zhang Rui wrote:
> On Mon, 2009-08-31 at 16:34 +0800, Pavel Machek wrote:
> > Hi!
> > 
> > > @@ -0,0 +1,32 @@
> > > +What:		/sys/class/als/als[0-N]/desc
> > > +Date:		Aug. 2009
> > > +KernelVersion:	2.6.32
> > > +Contact:	Zhang Rui <rui.zhang@intel.com>
> > > +Description:	Strings which descibes the current Ambient Light Sensor
> > > +		device. This is given by native ALS driver as part of
> > > +		registration. e.g: "acpi_als" for ACPI ALS devices.
> > > +		RO
> > 
> > Normal way to do that (backlight class does it, for example) is to
> > have acpi_als instead of als0, and get rid of desc field.
> 
> IMO, both are okay, hard to say which is preferred.
> Other sysfs classes like scsi_host, hwmon, input use this as well.
> and you don't have a really strong objection to this, right? :)

Actually I do. Inventing nonsensical als17 name, then having helpful
desc explaining it is acpi_als is pretty ugly...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

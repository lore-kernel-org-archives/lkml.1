Return-Path: <linux-kernel-owner+w=401wt.eu-S1751290AbZHLL5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbZHLL5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZHLL5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:57:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49387 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZHLL5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:57:01 -0400
Date: Wed, 12 Aug 2009 13:56:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 1/2] hwmon: Enhance the sysfs API for power meters.
Message-ID: <20090812115653.GJ24339@elf.ucw.cz>
References: <20090725004322.20709.96804.stgit@elm3a70.beaverton.ibm.com> <20090725004328.20709.57712.stgit@elm3a70.beaverton.ibm.com> <20090807180906.GD1728@ucw.cz> <20090808174020.GA29600@tux1.beaverton.ibm.com> <20090808214830.GC24153@elf.ucw.cz> <20090810211211.GB30815@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810211211.GB30815@tux1.beaverton.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-08-10 14:12:11, Darrick J. Wong wrote:
> On Sat, Aug 08, 2009 at 11:48:30PM +0200, Pavel Machek wrote:
> > 
> > Uhuh. This is hwmon documentation AFAICT; so a) it should be
> > documented here, and b) interface should be generic so that it works
> > without ACPI, too.
> 
> Perhaps it is time to set up a netlink interface for all the hwmon drivers?
> >From what I can tell, some of the chips can send interrupts when alarms go off,
> though I don't see much of an effort by the drivers to catch those interrupts.
> For sure there's no netlink socket that one can read for that sort of thing; a
> far as I can tell, client programs are expected to bang on sysfs periodicially
> to figure out when things have gone bad.

Is netlink right interface for that? Perhaps /sys files should be
pollable?

> > > The ACPI spec is silent on this matter.  It's not clear if the OS is supposed
> > > to monitor and take action on its own when power > cap, or if the hardware/BIOS
> > > will take action, or possibly both...?
> > 
> > Having user<->kernel interface that is well... uh... undocumented
> > makes little sense.
> 
> So it goes with ACPI.  Given that things like Node Manager and Active Energy
> Manager claim to be able to control power use, I would guess that it is
> generally likely that a power monitoring system would take action on its own to
> cut power use, and not necessarily bothering to tell the OS exactly what it's
> doing.

I guess this needs to be clarified/documented properly because it
should go anywhere near mainline.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

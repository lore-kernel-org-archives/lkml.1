Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYJOHZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYJOHZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 03:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYJOHZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 03:25:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56865 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbYJOHZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 03:25:13 -0400
Date: Wed, 15 Oct 2008 09:25:11 +0200
From: Pavel Machek <pavel@suse.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>, lm-sensors@lm-sensors.org,
       kernel list <linux-kernel@vger.kernel.org>
Cc: Thomas Renninger <trenn@suse.de>, Tejun Heo <tj@kernel.org>,
       Yan Burman <burman.yan@gmail.com>
Subject: Re: Accelerometer driver for HP laptops
Message-ID: <20081015072511.GA20607@atrey.karlin.mff.cuni.cz>
References: <48C984F5.5000804@tudelft.nl> <200809120736.06594.trenn@suse.de> <48CAD89F.1050806@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CAD89F.1050806@tremplin-utc.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I took a look at the driver, and it seems to work for me... I'd like
to get it to the mainline...

> >>Attached is our work-in-progress version of the driver for a fourth take
> >>on the LKML (it used to be mdps). It works really fine, with lots of
> >>"goodies" (like automatically convert the axes to fit to a standard,
> >>automatic power-off of the device when not in used) excepted the
> >>interrupt support for free-fall detection.

I wonder if mdps was really a better name? Driver is HP-specific
(because of the ACPI usage), not really chip specific... and lis3lv02d
looks like an alphabet soup to me...

Ok, it is a bit chip-specific, too...

What are the next plans... lm_sensors is listed as orphan in
MAINTAINERS, so I guess I'll clean it up a tiny bit then submit to akpm?

>  Documentation/hwmon/lis3lv02d      |   92 ++++
>  drivers/hwmon/Kconfig              |   23 +
>  drivers/hwmon/Makefile             |    1 +
>  drivers/hwmon/lis3lv02d.c          |  865 ++++++++++++++++++++++++++++++++++++
>  drivers/hwmon/lis3lv02d.h          |  149 ++++++
>  5 files changed, 1145 insertions(+), 16 deletions(-)

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

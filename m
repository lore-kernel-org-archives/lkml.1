Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbZGBLZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbZGBLZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 07:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZGBLZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 07:25:29 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:48808 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZGBLZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 07:25:28 -0400
Date: Thu, 2 Jul 2009 13:25:20 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Chris Verges" <chrisv@cyberswitching.com>
Cc: "Jonathan Cameron" <jic23@cam.ac.uk>, <linux-kernel@vger.kernel.org>,
       <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] adxl345 accelerometer hwmon driver
Message-ID: <20090702132520.2e02959e@hyperion.delvare>
In-Reply-To: <68FBE0F3CE97264395875AC1C468F22C152C1D@mail03.cyberswitching.local>
References: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local>
	<4A4BB4AB.7010003@cam.ac.uk>
	<68FBE0F3CE97264395875AC1C468F22C152BFA@mail03.cyberswitching.local>
	<20090701221310.1d6aa587@hyperion.delvare>
	<68FBE0F3CE97264395875AC1C468F22C152C1D@mail03.cyberswitching.local>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Wed, 1 Jul 2009 13:52:28 -0700, Chris Verges wrote:
> > Probably it's about time to put an end to this and kick all
> > accelerometer drivers out of drivers/hwmon.
> 
> Hi Jean,
> 
> This actually makes a lot of sense.  The remaining question is,
> "To where do we kick them?"
> 
> After reading Jonathan's iio.pdf, I'm all on-board with the
> adxl345 driver being placed in this new subsystem.  However,
> IIO subsystem isn't released into the "vanilla" kernel yet.
> 
> Until the IIO subsystem is finished and I can port the driver
> into it, what's the appropriate place for the adxl345 to
> reside?  misc?  A new directory?

This is a very valid question, and the current situation probably is
the result of it not having a simple answer.

We could create drivers/accelerometer and move the drivers there for
the time being. Or we can move them to drivers/misc until iio is
merged. Honestly, it would be great if iio could be finally merged, it
would help driver authors get their driver in good shape and in the
right place right away. But I know Jonathan is busy and I can't blame
him if things take time.

All in all, I don't really care where the drivers go, as long as it's
not in drivers/hwmon. So the choice is probably better left to the
authors of the accelerometer drivers. Once one driver is moved, the
rest will have to follow.

-- 
Jean Delvare

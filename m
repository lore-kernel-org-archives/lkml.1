Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbZGAUN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbZGAUN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbZGAUNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:13:17 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:35478 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZGAUNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:13:17 -0400
Date: Wed, 1 Jul 2009 22:13:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Chris Verges" <chrisv@cyberswitching.com>
Cc: "Jonathan Cameron" <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH] adxl345 accelerometer hwmon driver
Message-ID: <20090701221310.1d6aa587@hyperion.delvare>
In-Reply-To: <68FBE0F3CE97264395875AC1C468F22C152BFA@mail03.cyberswitching.local>
References: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local>
	<4A4BB4AB.7010003@cam.ac.uk>
	<68FBE0F3CE97264395875AC1C468F22C152BFA@mail03.cyberswitching.local>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 12:19:02 -0700, Chris Verges wrote:
> > What are you actually doing with it?  If you aren't doing hardware
> > monitoring then I would expect you aren't going to receive a
> > favourable response on here.
> 
> The ADXL345 is a 3D accelerometer.  It's very similar to the following
> chips already in the HWMON section of the kernel:
> 
>    - SENSORS_LIS3LV02D
>    - SENSORS_APPLESMC
> 
> The driver provides 3D axis data when the user polls the chip via the
> sysfsinterface.

A few accelerometer drivers were originally added to drivers/hwmon
because the chips also included some hwmon features (e.g. temperature
sensor.) Now every new accelerometer driver gets dropped in
drivers/hwmon "because there are other accelerometer drivers there".
The LIS3LV02D driver is a perfect example of this... the device is not
even registered as a hwmon driver! This driver definitely doesn't
belong there.

Probably it's about time to put an end to this and kick all
accelerometer drivers out of drivers/hwmon.

-- 
Jean Delvare

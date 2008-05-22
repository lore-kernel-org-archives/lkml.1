Return-Path: <linux-kernel-owner+w=401wt.eu-S936122AbYEVJfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936122AbYEVJfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932795AbYEVJfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:35:07 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:42704 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760509AbYEVJfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:35:06 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <48353E45.2080903@cam.ac.uk>
Date: Thu, 22 May 2008 10:35:01 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Jean Delvare <khali@linux-fr.org>, spi-devel-general@lists.sourceforge.net,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       LM Sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [spi-devel-general] Accelerometer,	Gyros and ADC's etc within
 the kernel.
References: <4832A211.4040206@gmail.com>	<20080520132817.03fb74ea@hyperion.delvare> <200805211752.15670.david-b@pacbell.net>
In-Reply-To: <200805211752.15670.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,
> On Tuesday 20 May 2008, Jean Delvare wrote:
>> This all sounds quite different from our hwmon drivers. Our hwmon
>> drivers read all the sensor values at once and cache the readings for a
>> couple seconds, so you can't get an instant reading at any time, and
>> they also don't support interrupts in general.
> 
> That's something of an issue when the hardware monitor
> triggers alarms though, right?  I couldn't figure out
> how to get a TMP75 alert out to any userspace code that
> would care, to pick one example, even after teaching
> the i2c core how to handle SMBus alerts.  ;)
> 
> I suppose this just emphasizes the point made by Hans
> that we kind of need (industrial) "control" components
> (or "data acquisition"?) not just "monitoring" ones.
I get the feeling even the name is going to evolve for some time to come, 
getting broader as and when we add more classes of device.
> Such alarms are of course different from the "data
> ready" signals of an accelerometer.
Whilst this is true, most accelerometers also have "alarm" triggers, for example
the ST LIS3L02DQ will raise a pin on configurable conditions such as thresholds
and even a double click detector (though I've never tried them!).  I suppose we
will ideally support this functionality as well.
--
Jonathan Cameron

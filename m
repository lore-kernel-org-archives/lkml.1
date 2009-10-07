Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbZJGR1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbZJGR1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934271AbZJGR1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:27:17 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:11837 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934200AbZJGR1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:27:11 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4ACCCF48.5090005@tremplin-utc.net>
Date: Wed, 07 Oct 2009 19:26:32 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20090830 Mandriva/2.0.0.23-2mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>, linux-kernel@vger.kernel.org,
       LM Sensors <lm-sensors@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/2] LIS3LV02D I2C driver
References: <1254391591-9696-1-git-send-email-samu.p.onkalo@nokia.com> <4ACCC273.1030308@gmail.com> <4ACCC957.3060802@tremplin-utc.net>
In-Reply-To: <4ACCC957.3060802@tremplin-utc.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 07-10-09 19:01, Éric Piel schreef:
> Op 07-10-09 18:31, Jonathan Cameron schreef:
>> Just a quick heads up wrt overlapping work.
>>
>> For the i2c support Kalhan Trisal has been posting patches for i2c
>> support for this
>> driver to the lm-sensors list for some time and the latest version of that
>> set is also pretty clean.
> You mean this post, right?
> http://lists.lm-sensors.org/pipermail/lm-sensors/2009-August/026505.html
> "Accelerometer driver for STMicroeletronics-LIS331DL-three-axis-digital"
> Thanks for the heads up, I had never heard of this driver before.

:
> Kalhan, would
> you mind having a look at the patch from Samu, and see what is required
> to get your LIS331DL working with the lis3lv02d driver? It should be
> very little and avoid duplication of efforts :-)
Ah, bah,
I see you have actually already more or less done this!
http://lists.lm-sensors.org/pipermail/lm-sensors/2009-October/026840.html
"I2C glue layer for lis3lv02d STMicroelectronics digital accelerometer"

The main thing you forgot to do with this patch was to CC the maintainer
of the driver (AKA me) ;-)

Anyway, this version is _very_ close to the one from Samu. It has just
all the basics, really clean! Samu has already added some nifty things
(like changing the axis conversion, support for suspend...). So it
should _really_ easy to converge :-) As Samu's patch is already in
Andrew's queue, I think it's simpler to leave it as it, and just to keep
my request to you, Kalhan, to check that it works for your hardware as
well.

See you,
Eric
PS: in a previous iteration, you had fixed the rate reading function for
the 8 bits version of the hardware. Would you mind sending this as a
independent patch, or just letting me "rip off" your fix?

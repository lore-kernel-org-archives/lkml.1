Return-Path: <linux-kernel-owner+w=401wt.eu-S1759641AbZJGRVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641AbZJGRVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759626AbZJGRVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:21:08 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:46404 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759624AbZJGRVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:21:07 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4ACCCDE7.1090508@gmail.com>
Date: Wed, 07 Oct 2009 18:20:39 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091007)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
CC: Samu Onkalo <samu.p.onkalo@nokia.com>, linux-kernel@vger.kernel.org,
       LM Sensors <lm-sensors@lm-sensors.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
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

Éric Piel wrote:
> Op 07-10-09 18:31, Jonathan Cameron schreef:
>   
>> Just a quick heads up wrt overlapping work.
>>
>> For the i2c support Kalhan Trisal has been posting patches for i2c
>> support for this
>> driver to the lm-sensors list for some time and the latest version of that
>> set is also pretty clean.
>>     
> You mean this post, right?
> http://lists.lm-sensors.org/pipermail/lm-sensors/2009-August/026505.html
> "Accelerometer driver for STMicroeletronics-LIS331DL-three-axis-digital"
> Thanks for the heads up, I had never heard of this driver before.
>   
I think that was the original post. (sorry should have added references!)

> Well, it's for the LIS331DL, not the LIS3LV02DL (12 bits) or the
> LIS302DL (8 bits) (both supported by lis3lv02d driver). That said,
> according to the specs, it seems to be _very_ similar to the LIS302DL,
> they even report the same "who_am_i" value. Just some special features
> are different (free fall detection for instance).
>   
Yes, that's why he was advised to combine it with your driver leading
via about 3 revisions
to
http://lists.lm-sensors.org/pipermail/lm-sensors/2009-October/026840.html
(removed a few pointless headers from previous version
http://lists.lm-sensors.org/pipermail/lm-sensors/2009-September/026706.html
.)


which at first glance is pretty much the same as Samu's driver.
(hence real issue with overlapping work).

I do wonder if it is worth adding a mailing list entry to the driver
MAINTAINERS
entry (unless lm-sensors is where you do want anything relevant to be
discussed?).
Problem here is this evolved in a thread not initially related to your
driver and hence I guess no one noticed you weren't cc'd when it became
relevant.

Jonathan

p.s. Kalhan, btw, just noticed a typo in the patch message :
Macroelectronics->Microelectronics.

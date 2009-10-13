Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbZJMKVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbZJMKVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759287AbZJMKVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:21:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:57234 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851AbZJMKVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:21:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,550,1249282800"; 
   d="scan'208";a="502630895"
From: "Trisal, Kalhan" <kalhan.trisal@intel.com>
To: "samu.p.onkalo@nokia.com" <samu.p.onkalo@nokia.com>,
       =?utf-8?B?ZXh0IMOJcmljIFBpZWw=?= <eric.piel@tremplin-utc.net>
CC: Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Oct 2009 15:50:10 +0530
Subject: RE: [RFC][PATCH 0/2] LIS3LV02D I2C driver
Thread-Topic: [RFC][PATCH 0/2] LIS3LV02D I2C driver
Thread-Index: AcpL7d4MWRwB4D9IRJCg98SNk/pU8QAAGLUw
Message-ID: <3CA6C6D9F70D314CA34352990B57DA1539AE7E1D@bgsmsx502.gar.corp.intel.com>
References: <1254391591-9696-1-git-send-email-samu.p.onkalo@nokia.com>
	 <4ACCC273.1030308@gmail.com> <4ACCC957.3060802@tremplin-utc.net>
	 <4ACCCF48.5090005@tremplin-utc.net> <1255428813.3974.9.camel@4fid08082>
In-Reply-To: <1255428813.3974.9.camel@4fid08082>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n9DAQJ16005443



-----Original Message-----
From: Onkalo Samu [mailto:samu.p.onkalo@nokia.com] 
Sent: Tuesday, October 13, 2009 3:44 PM
To: ext Ã‰ric Piel; Trisal, Kalhan
Cc: Jonathan Cameron; linux-kernel@vger.kernel.org; LM Sensors; Jean Delvare; Andrew Morton
Subject: Re: [RFC][PATCH 0/2] LIS3LV02D I2C driver

On Wed, 2009-10-07 at 19:26 +0200, ext Ã‰ric Piel wrote:
> Op 07-10-09 19:01, Ã‰ric Piel schreef:
> > Op 07-10-09 18:31, Jonathan Cameron schreef:
> >> Just a quick heads up wrt overlapping work.
> >>
> >> For the i2c support Kalhan Trisal has been posting patches for i2c
> >> support for this
> >> driver to the lm-sensors list for some time and the latest version of that
> >> set is also pretty clean.
> > You mean this post, right?
> > http://lists.lm-sensors.org/pipermail/lm-sensors/2009-August/026505.html
> > "Accelerometer driver for STMicroeletronics-LIS331DL-three-axis-digital"
> > Thanks for the heads up, I had never heard of this driver before.
> 
> :
> > Kalhan, would
> > you mind having a look at the patch from Samu, and see what is required
> > to get your LIS331DL working with the lis3lv02d driver? It should be
> > very little and avoid duplication of efforts :-)
> Ah, bah,
> I see you have actually already more or less done this!
> http://lists.lm-sensors.org/pipermail/lm-sensors/2009-October/026840.html
> "I2C glue layer for lis3lv02d STMicroelectronics digital accelerometer"
> 
> The main thing you forgot to do with this patch was to CC the maintainer
> of the driver (AKA me) ;-)
> 
> Anyway, this version is _very_ close to the one from Samu. It has just
> all the basics, really clean! Samu has already added some nifty things
> (like changing the axis conversion, support for suspend...). So it
> should _really_ easy to converge :-) As Samu's patch is already in
> Andrew's queue, I think it's simpler to leave it as it, and just to keep
> my request to you, Kalhan, to check that it works for your hardware as
> well.

Hi Kalhan,

Have you been able to test my patch if it works also for your HW?

http://marc.info/?l=linux-kernel&m=125472767421625&w=2

http://marc.info/?l=linux-kernel&m=125472767421629&w=2

http://marc.info/?l=linux-kernel&m=125472767421639&w=2
 
Br,
Samu


Hi Samu, 
  I haven't tested your patch yet but it will work.
   I have seen the patch, the glue layer is exactly same 
   what I have also tested part of my driver.

Br
Kalhan

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

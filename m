Return-Path: <linux-kernel-owner+w=401wt.eu-S933856AbZJMKQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856AbZJMKQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759299AbZJMKQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:16:18 -0400
Received: from smtp.nokia.com ([192.100.105.134]:54485 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbZJMKQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:16:17 -0400
Subject: Re: [RFC][PATCH 0/2] LIS3LV02D I2C driver
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: ext =?ISO-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4ACCCF48.5090005@tremplin-utc.net>
References: <1254391591-9696-1-git-send-email-samu.p.onkalo@nokia.com>
	 <4ACCC273.1030308@gmail.com> <4ACCC957.3060802@tremplin-utc.net>
	 <4ACCCF48.5090005@tremplin-utc.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Tue, 13 Oct 2009 13:13:33 +0300
Message-Id: <1255428813.3974.9.camel@4fid08082>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Oct 2009 10:13:40.0555 (UTC) FILETIME=[D624D1B0:01CA4BED]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 19:26 +0200, ext Éric Piel wrote:
> Op 07-10-09 19:01, Éric Piel schreef:
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




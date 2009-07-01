Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZGATTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZGATTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZGATTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:19:06 -0400
Received: from p01c12o145.mxlogic.net ([208.65.145.68]:48804 "EHLO
	p01c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZGATTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:19:05 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [lm-sensors] [PATCH] adxl345 accelerometer hwmon driver
Date: Wed, 1 Jul 2009 12:19:02 -0700
Message-ID: <68FBE0F3CE97264395875AC1C468F22C152BFA@mail03.cyberswitching.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [lm-sensors] [PATCH] adxl345 accelerometer hwmon driver
Thread-Index: Acn6f7lJY53Q4cFiQRKB7iLsq8qNgQAAEWUA
References: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local> <4A4BB4AB.7010003@cam.ac.uk>
From: "Chris Verges" <chrisv@cyberswitching.com>
To: "Jonathan Cameron" <jic23@cam.ac.uk>
Cc: <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2009062201)]
X-MAIL-FROM: <chrisv@cyberswitching.com>
X-SOURCE-IP: [64.81.28.110]
X-AnalysisOut: [v=1.0 c=1 a=3RK18MZZl1IA:10 a=4zsJQXJisSY22NXBO5KRuA==:17 ]
X-AnalysisOut: [a=0DpEE7aoRZBKQ5yqYUgA:9 a=4remCksILeEShiROk28A:7 a=wHdo_K]
X-AnalysisOut: [F_Mg8QMzPf6xtmLnFAlPMA:4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

Thanks for the response!

> Just for reference this chip is definitely on my list of ones to
support
> via the Industrial I/O (iio) framework, I just haven't managed to get
hold
> of one as yet!

If you need a sample set, let me know off the mailing list.  I may be
able
to ship a couple to you ... need to check our available stock.  I think
ours are BGAs, in case you have the intention of soldering by hand.  :-)

> What are you actually doing with it?  If you aren't doing hardware
> monitoring then I would expect you aren't going to receive a
favourable
> response on here.

The ADXL345 is a 3D accelerometer.  It's very similar to the following
chips already in the HWMON section of the kernel:

   - SENSORS_LIS3LV02D
   - SENSORS_APPLESMC

The driver provides 3D axis data when the user polls the chip via the
sysfs
interface.

The ADXL345 has the additional capability of being a "tap-touch"
detector --
almost like an input device, if you will -- but this driver doesn't
expose
that functionality.  Maybe in the future.

> I'll take a look at the actual code tomorrow.  Always good to see
another
> accelerometer driver.

Thanks!  Looking forward to the feedback.

Chris

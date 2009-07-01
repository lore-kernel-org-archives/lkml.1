Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZGAUwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZGAUwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbZGAUwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:52:32 -0400
Received: from p01c12o143.mxlogic.net ([208.65.145.66]:44997 "EHLO
	p01c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZGAUwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:52:31 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] adxl345 accelerometer hwmon driver
Date: Wed, 1 Jul 2009 13:52:28 -0700
Message-ID: <68FBE0F3CE97264395875AC1C468F22C152C1D@mail03.cyberswitching.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] adxl345 accelerometer hwmon driver
Thread-Index: Acn6iFz4soyNKSULSSC6jz4Z1hpyogAAcMSw
References: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local><4A4BB4AB.7010003@cam.ac.uk><68FBE0F3CE97264395875AC1C468F22C152BFA@mail03.cyberswitching.local> <20090701221310.1d6aa587@hyperion.delvare>
From: "Chris Verges" <chrisv@cyberswitching.com>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: "Jonathan Cameron" <jic23@cam.ac.uk>, <linux-kernel@vger.kernel.org>,
       <lm-sensors@lm-sensors.org>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2009062201)]
X-MAIL-FROM: <chrisv@cyberswitching.com>
X-SOURCE-IP: [64.81.28.110]
X-AnalysisOut: [v=1.0 c=1 a=RN8TcIVZXm8A:10 a=4zsJQXJisSY22NXBO5KRuA==:17 ]
X-AnalysisOut: [a=3OZ1w2rYJNQCtacGfwsA:9 a=CvFK8nZh_F5bNFwaZKPYX9PHgbIA:4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Probably it's about time to put an end to this and kick all
> accelerometer drivers out of drivers/hwmon.

Hi Jean,

This actually makes a lot of sense.  The remaining question is,
"To where do we kick them?"

After reading Jonathan's iio.pdf, I'm all on-board with the
adxl345 driver being placed in this new subsystem.  However,
IIO subsystem isn't released into the "vanilla" kernel yet.

Until the IIO subsystem is finished and I can port the driver
into it, what's the appropriate place for the adxl345 to
reside?  misc?  A new directory?

Chris

P.S. All references to hwmon will be removed, and the
programmer who added them in will be flogged.  :-) Thanks for
pointing that out!

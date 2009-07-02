Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZGBSAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZGBSAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZGBSAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:00:14 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:40486 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZGBSAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:00:13 -0400
X-IronPort-AV: E=Sophos;i="4.42,336,1243828800"; 
   d="scan'208";a="3370284"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [lm-sensors] [PATCH] adxl345 accelerometer hwmon driver
Date: Thu, 2 Jul 2009 18:59:46 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0C2497CC@limkexm3.ad.analog.com>
In-Reply-To: <8bd0f97a0907021043l30a34e6dh581ea5e96130d7eb@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [lm-sensors] [PATCH] adxl345 accelerometer hwmon driver
Thread-Index: Acn7PLHFd6jE0ZNkSLqFIi229re9CAAAOmxw
References: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local> <4A4CF07B.3090600@cam.ac.uk> <8bd0f97a0907021043l30a34e6dh581ea5e96130d7eb@mail.gmail.com>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Jonathan Cameron" <jic23@cam.ac.uk>
CC: "Chris Verges" <chrisv@cyberswitching.com>, <linux-kernel@vger.kernel.org>,
       <lm-sensors@lm-sensors.org>, "Robin Getz" <rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 02 Jul 2009 17:59:46.0519 (UTC) FILETIME=[E29C0670:01C9FB3E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From: Mike Frysinger [mailto:vapier.adi@gmail.com]
>On Thu, Jul 2, 2009 at 13:38, Jonathan Cameron wrote:
>> One interesting thing I just came across whilst searching lkml for
>> your post to reply to, was that Mike Frysinger submited a patch
>> adding some board support for an adx34x driver to bf548-ezkit.
>> I've not seen any sign of this anywhere else as yet (it hasn't
>> hit the input list which would be the obvious place) I've copied in
>> both people who signed off.  Michael or Mike able to give us more info?
>
>that's because we're still in the process of making sure it is stable.
> I2C is a pita to work with.
>http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=43d4cabbdeb5c24f84b159c5
>dc369c1a60844a48
>
>the advantage here is that we have been testing our driver with actual
>hardware ...
>-mike

Funny - we've been both working on a driver for the same device.
The driver is stable and from my side ready to send upstream.

Documentation can be found here:

http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:drivers:adxl34x


However we target driver/input since we targeted it for HID and gaming devices.

Best regards,
Michael

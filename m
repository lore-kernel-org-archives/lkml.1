Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab0BERdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:33:16 -0500
Received: from p01c12o148.mxlogic.net ([208.65.145.71]:46354 "EHLO
	p01c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab0BERdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:33:15 -0500
X-MXL-Hash: 4b6c565b66a520b3-a79175a51a02d732c815d9b5f753e7ee3d5f4578
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] linux-2.6.32-directemp
Date: Fri, 5 Feb 2010 09:32:52 -0800
Message-ID: <68FBE0F3CE97264395875AC1C468F22C24A5D1@mail03.cyberswitching.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] linux-2.6.32-directemp
thread-index: Acqmh86sM7fWZxkER/qfciT97t0hUwAALOpQ
References: <68FBE0F3CE97264395875AC1C468F22C24A5BD@mail03.cyberswitching.local> <20100205171659.GF14145@suse.de>
From: "Chris Verges" <chrisv@cyberswitching.com>
To: "Greg KH" <gregkh@suse.de>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Rob Owings" <rowings@thermistor.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <chrisv@cyberswitching.com>
X-SOURCE-IP: [64.81.28.110]
X-AnalysisOut: [v=1.0 c=1 a=4zsJQXJisSY22NXBO5KRuA==:17 a=RMC-Ytf9o83QZ5d1]
X-AnalysisOut: [fsgA:9 a=GcT2hHQocC9bmONBFKHAfCFqtbwA:4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is a kernel driver really needed for this device?  You could do this
all
> in userspace with libusb/usbfs and not need a driver, right?
>
> That's what we do for other USB thermometers today.

Hi Greg,

I assumed that there were few to no USB thermometers in use with Linux.
Looking at the kernel, there seems to be Cypress USB thermometer driver
listed, but it's for a hobby project that isn't actually a product.
Based on the cytherm driver, I figured support was to be added to the
kernel.

I'd be happy to read up on libusb/usbfs.  Thanks for introducing it.
For anyone who wants DirecTEMP support before a port to libusb/usbfs is
done (no ETA), feel free to use this driver.

Thanks,
Chris

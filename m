Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbZAOGe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbZAOGe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 01:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbZAOGet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 01:34:49 -0500
Received: from 89.6b.364a.static.theplanet.com ([74.54.107.137]:56658 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbZAOGes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 01:34:48 -0500
Message-ID: <496ED8F6.6030201@compulab.co.il>
Date: Thu, 15 Jan 2009 08:34:30 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@sirena.org.uk>, Samuel Ortiz <sameo@openedhand.com>,
       felipe.balbi@nokia.com, Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH 2.6.29-rc1-git4] mfd: da9030 usb charge pump support 
 within mfd driver.
References: <496E2BE5.1050803@cam.ac.uk> <f17812d70901141704n1ac3e8a7q56410f175b833ef6@mail.gmail.com>
In-Reply-To: <f17812d70901141704n1ac3e8a7q56410f175b833ef6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Eric Miao wrote:
> On Thu, Jan 15, 2009 at 2:16 AM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
>> From: Jonathan Cameron <jic23@cam.ac.uk>
>>
>> Add support for changing the mode of the da9030 usb charge pump
>>
> 
> Well, if it is totally USB charger related, I'd suggest to move this into
> the dedicated driver. This mfd/da903x.c serves as a common code
> base for all sub-peripherals.

It's not exactly related to the charger, it's rather related to the USB voltage
supplied to USB devices attached to PXA OHCI.
Indeed the mfd/da903x.c serves as a common core for sub-peripherals, but IMHO
adding a subdevice driver because of single method doesn't worth the overhead.
I'm for the solution Jonathan proposes.


-- 
Sincerely yours,
Mike.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbZEKIrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbZEKIrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbZEKIrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:47:22 -0400
Received: from senator.holtmann.net ([87.106.208.187]:45911 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbZEKIrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:47:21 -0400
Subject: Re: Regression: Problem in using USB Bluetooth Dongle (Worked fine
 in  2.6.24.x)
From: Marcel Holtmann <marcel@holtmann.org>
To: Brian Marete <bgmarete@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <6dd519ae0905110030n2abd87c0j507e476fb5622d87@mail.gmail.com>
References: <6dd519ae0905080528j79640bb0l8fe475b2f09e6bc4@mail.gmail.com>
	 <1241821498.4903.69.camel@localhost.localdomain>
	 <6dd519ae0905110030n2abd87c0j507e476fb5622d87@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 01:46:54 -0700
Message-Id: <1242031614.3384.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

> >> At least until kernel version 2.6.24, I was able to use my USB
> >> bluetooth dongle to download contacts from my phone. I made a jump
> >> from 2.6.24 to 2.6.27, so I am not sure exactly which kernel version
> >> starts the problem, but all kernels from the latter (2.6.27) now do
> >> not work. The latest kernel I have tested is 2.6.29.2.
> >
> > can you test 2.6.30-rc4 or bluetooth-testing.git. I am pretty sure that
> > whatever broke in 2.6.27 has been fixed by now. Some cheapo USB dongles
> > behaved wrongly and it was a long time not clear what caused it.
>
> Alas, the regression is still there in 2.6.30-rc5 which I tested over
> the weekend.
> 
> I also forgot to mention that, even with the kernels with the
> regression, device pairing using the dongle still works.
> 
> Would a packet capture (usbmon) help? Willing to capture whatever
> other debugging data that you think may help

if device pairing works fine, the I guess this is a different problem.
It could be that your USB host controller doesn't like the device. Or
you forgot to load the EHCI driver or something. Otherwise your dongle
should work fine. Since pairing works, what does hciconfig -a says?

Regards

Marcel



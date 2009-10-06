Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbZJFM40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbZJFM40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbZJFM4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:56:25 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:16959 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbZJFM4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:56:24 -0400
X-IronPort-AV: E=Sophos;i="4.44,513,1249272000"; 
   d="scan'208";a="7234824"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
Date: Tue, 6 Oct 2009 13:55:45 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0E3F4420@limkexm3.ad.analog.com>
In-Reply-To: <20091006123658.GA31079@rakim.wolfsonmicro.main>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
thread-index: AcpGgbes6/Wn1m+3RPeHnPcjCLE2kwAAcWGQ
References: <1253682664-27040-1-git-send-email-vapier@gentoo.org> <1254815071-15822-1-git-send-email-vapier@gentoo.org> <20091006115543.GH27168@sirena.org.uk> <8A42379416420646B9BFAC9682273B6D0E3F4348@limkexm3.ad.analog.com> <20091006123658.GA31079@rakim.wolfsonmicro.main>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
CC: "Mike Frysinger" <vapier@gentoo.org>,
       "Samuel Ortiz" <sameo@linux.intel.com>,
       <uclinux-dist-devel@blackfin.uclinux.org>,
       <linux-kernel@vger.kernel.org>, "Bryan Wu" <cooloney@kernel.org>
X-OriginalArrivalTime: 06 Oct 2009 12:55:47.0311 (UTC) FILETIME=[52D9BFF0:01CA4684]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>On Tue, Oct 06, 2009 at 01:23:52PM +0100, Hennerich, Michael wrote:
>> >From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>
>> >This notifier stuff looks an awful lot like an interrupt controller
>> >driver.  Now that it's possible to implement support for an I2C/SPI
>> >driven interrupt controller it'd be good to use that rather than
having
>> >a custom API if that's possible.
>
>> Honestly this notifier chain is a clean approach and serves its
purpose
>> here pretty well.
>> IMHO it's much more preferable than pretending there is a virtual
GPIO
>> that doesn't exist and a MFD subdev could request.
>
>I'm not sure what the association with virtual gpios is?  This is all
>separate to gpiolib except in that it would mean that a gpio driver for
>the device would be able to export these interrupts to its clients.

This is what I meant.
So you propose having the MFD Core as well as its subdevs requesting the
ADP5520 IRQ (client->irq) IRQF_SHARED? I think we already excluded us
from using this option when we were asked to move to the NEW threaded
irqs?


-Michael



Return-Path: <linux-kernel-owner+w=401wt.eu-S933554AbXHPLdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554AbXHPLdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXHPLdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:33:43 -0400
Received: from spirit.analogic.com ([204.178.40.4]:2184 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbXHPLdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:33:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 16 Aug 2007 11:33:41.0138 (UTC) FILETIME=[4B96E720:01C7DFF9]
Content-class: urn:content-classes:message
Subject: Re: USB Keyboard
Date: Thu, 16 Aug 2007 07:33:40 -0400
Message-ID: <Pine.LNX.4.61.0708160724001.17168@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.64.0708161100340.2460@twin.jikos.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: USB Keyboard
Thread-Index: Acff+Uu9XCC8Stv5RHW1QKMCFeEOfA==
References: <Pine.LNX.4.61.0708151320380.8581@chaos.analogic.com> <Pine.LNX.4.64.0708161100340.2460@twin.jikos.cz>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Cc: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Aug 2007, Jiri Kosina wrote:

> On Wed, 15 Aug 2007, linux-os (Dick Johnson) wrote:
>
>> I thought maybe there was a bug that had been fixed in later versions so
>> I built and installed Linux-2.6.22.1. The required usbhid.ko doesn't
>> build, even though it is enabled in ".config."
>
> Could you plase send me your full .config? The usbhid module builds just
> fine, please doble check on your side.
>
> Thanks,
>
> -- 
> Jiri Kosina
>
Okay. I found what was different. It does actually build, but it
is now put into a completely different directory, 
/lib/modules/2.6.22.1/kernel/drivers/hid/usbhid, and requires
/lib/modules/2.6.22.1/kernel/drivers/input/ff-memless.ko
to be installed before it can be. None of this is documented
and it makes upgrading extremely difficult, expecially when a
keyboard won't work anymore.

BYW, it did fix the problem with the old driver.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.

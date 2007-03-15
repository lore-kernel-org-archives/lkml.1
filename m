Return-Path: <linux-kernel-owner+w=401wt.eu-S1751280AbXCOVkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbXCOVkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbXCOVkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:40:42 -0400
Received: from spirit.analogic.com ([204.178.40.4]:4210 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXCOVkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:40:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 15 Mar 2007 21:40:39.0792 (UTC) FILETIME=[932EFF00:01C7674A]
Content-class: urn:content-classes:message
Subject: Re: [linux-usb-devel] USB Keyboard
Date: Thu, 15 Mar 2007 17:40:39 -0400
Message-ID: <Pine.LNX.4.61.0703151736070.5767@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.44L0.0703151723350.2482-100000@iolanthe.rowland.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-usb-devel] USB Keyboard
Thread-Index: AcdnSpNXquCl+1NcSGKR+LTvDOKEAg==
References: <Pine.LNX.4.44L0.0703151723350.2482-100000@iolanthe.rowland.org>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Mar 2007, Alan Stern wrote:

> On Thu, 15 Mar 2007, Dmitry Torokhov wrote:
>
>> On 3/15/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>>> echo "Loading uhci-hcd.ko module"
>>> insmod /lib/uhci-hcd.ko
>>> echo "Loading ehci-hcd.ko module"
>>> insmod /lib/ehci-hcd.ko
>>
>> I don't see you loading OHCI and I thought AMD boxes used that flavor.
>
> It depends on the chipset used for the motherboard.  Intel and VIA use
> UHCI, pretty much everyone else uses OHCI.
>
> Dick, there's an even simpler way to debug this.  Install your special CD
> on a machine with an old-fashioned PS/2 keyboard and use that!
>
> Alan Stern

It's not the same hardware and all the machines that I tried that
have keyboards end up WORKING with the USB keyboard as well!  But
Dmitry Torokhov was right! I just burned a CD with all three modules,
and the keyboard works! I didn't bother to check the DEBUG messages.
It's interesting that the "wrong" module loaded fine with no warnings
that it might not be the correct one!

Thanks a lot.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5615.29 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.

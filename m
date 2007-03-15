Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbXCOVlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbXCOVlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXCOVlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:41:37 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:2101 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbXCOVlg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:41:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 15 Mar 2007 21:41:33.0447 (UTC) FILETIME=[B32A1970:01C7674A]
Content-class: urn:content-classes:message
Subject: Re: [linux-usb-devel] USB Keyboard
Date: Thu, 15 Mar 2007 17:41:33 -0400
Message-ID: <Pine.LNX.4.61.0703151740460.5767@chaos.analogic.com>
In-Reply-To: <d120d5000703151307w110c5258q6a4c53381e71e89c@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-usb-devel] USB Keyboard
Thread-Index: AcdnSrMxbmTEplxkQvSYPpWSCHuf5A==
References: <Pine.LNX.4.44L0.0703151506010.2482-100000@iolanthe.rowland.org> <Pine.LNX.4.61.0703151541430.4459@chaos.analogic.com> <d120d5000703151307w110c5258q6a4c53381e71e89c@mail.gmail.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Linux kernel" <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Mar 2007, Dmitry Torokhov wrote:

> On 3/15/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
>> echo "Loading uhci-hcd.ko module"
>> insmod /lib/uhci-hcd.ko
>> echo "Loading ehci-hcd.ko module"
>> insmod /lib/ehci-hcd.ko
>
> I don't see you loading OHCI and I thought AMD boxes used that flavor.
>
>> echo "Loading usbhid.ko module"
>> insmod /lib/usbhid.ko
>> echo "Loading usbkbd.ko module"
>> insmod /lib/usbkbd.ko
>> echo "sleeping for a few seconds"
>> sleep 2
>> echo "Mounting root filesystem"
>> /bin/findroot
>> mount -o defaults --ro -t iso9660 /dev/root /sysroot
>> pivot_root /sysroot /sysroot/initrd
>> umount /initrd/proc
>> exec /sbin/init
>>
>
> -- 
> Dmitry
>

Yes! You are correct!  I added that module and now the keyboard works!
Thanks!

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5615.29 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.

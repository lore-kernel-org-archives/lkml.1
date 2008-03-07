Return-Path: <linux-kernel-owner+w=401wt.eu-S1762078AbYCGW6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078AbYCGW6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 17:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbYCGW54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 17:57:56 -0500
Received: from senator.holtmann.net ([87.106.208.187]:35507 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726AbYCGW5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 17:57:55 -0500
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-Id: <87EF029F-B8F4-4A30-8D43-667AF33D89AD@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Karsten Keil <kkeil@suse.de>
In-Reply-To: <20080307210810.GB671@pingi.kke.suse.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] [BLUETOOTH] Add another Broadcom device
Date: Fri, 7 Mar 2008 23:57:47 +0100
References: <20080307201034.GA671@pingi.kke.suse.de> <68E3DB35-04A3-475E-8C3F-B2F48E778487@holtmann.org> <20080307210810.GB671@pingi.kke.suse.de>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karsten,

>>> This patch adds another Broadcom BCM2045 based device to the
>>> blacklist, with these settings the micro dongle works on my system.
>>>
>>> Signed-off-by: Karsten Keil <kkeil@suse.de>
>>> ---
>>> drivers/bluetooth/hci_usb.c |    1 +
>>> 1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/ 
>>> hci_usb.c
>>> index 372c7ef..f16c94c 100644
>>> --- a/drivers/bluetooth/hci_usb.c
>>> +++ b/drivers/bluetooth/hci_usb.c
>>> @@ -116,6 +116,7 @@ static struct usb_device_id blacklist_ids[] = {
>>> 	{ USB_DEVICE(0x0a5c, 0x2009), .driver_info = HCI_BCM92035 },
>>>
>>> 	/* Broadcom BCM2045 */
>>> +	{ USB_DEVICE(0x0a5c, 0x2039), .driver_info = HCI_RESET |
>>> HCI_WRONG_SCO_MTU },
>>> 	{ USB_DEVICE(0x0a5c, 0x2101), .driver_info = HCI_RESET |
>>> HCI_WRONG_SCO_MTU },
>>
>> before I sign off on this one, can you include the part from /proc/ 
>> bus/
>> usb/devices for this dongle.
>>
>
> I do not have /proc/bus/usb on this machine, but can give you the  
> output of
> lsusb -v
>
> And it is this device:
> http://cgi.ebay.de/USB-Bluetooth-Nano-Dongle-Micro-Adapter-Mini-V2-0-EDR_W0QQitemZ270217529196QQihZ017QQcategoryZ79469QQssPageNameZWDVWQQrdZ1QQcmdZViewItem
>
> It work fine with a BT mouse on my notebook with this patch.
>
>
> Bus 003 Device 006: ID 0a5c:2039 Broadcom Corp.
> Device Descriptor:
>  bLength                18
>  bDescriptorType         1
>  bcdUSB               2.00
>  bDeviceClass          224 Wireless
>  bDeviceSubClass         1 Radio Frequency
>  bDeviceProtocol         1 Bluetooth
>  bMaxPacketSize0        64
>  idVendor           0x0a5c Broadcom Corp.
>  idProduct          0x2039
>  bcdDevice            1.00
>  iManufacturer           1 Broadcom Corp
>  iProduct                2 BCM92045B3 ROM

looks good to me.

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


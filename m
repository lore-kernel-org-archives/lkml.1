Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYKZQfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYKZQfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYKZQfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:35:46 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:38764 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYKZQfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:35:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RGS+wh7Wb3/aG02txAewQv4W9xjIO7uSnuGQtc8QBjYpOhc4PFBWKWRfv6hS8NnqPL
         npSr9sr09wN01gPVM1/NMHlhdXBvozImugZ4++jlQ9ssDg0WtIzoXrH4Tr5GYYU/TzGC
         CACMl19lNJDfbND+C5xqueeYYY88Dv8lAdK+s=
Message-ID: <3aaafc130811260835o16107cffgee60e12218f814d9@mail.gmail.com>
Date: Wed, 26 Nov 2008 11:35:45 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [PATCH 1/1] HID: Apple alu wireless keyboards are bluetooth devices
Cc: "Jan Scholz" <scholz@fias.uni-frankfurt.de>,
       "Tobias Mueller" <Tobias_Mueller@twam.info>, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.10.0811261632340.19853@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227710025-23592-1-git-send-email-Scholz@fias.uni-frankfurt.de>
	 <1227710025-23592-2-git-send-email-Scholz@fias.uni-frankfurt.de>
	 <alpine.LNX.1.10.0811261553010.19853@jikos.suse.cz>
	 <87ej0ywm79.fsf@scholz.fias.uni-frankfurt.de>
	 <alpine.LNX.1.10.0811261632340.19853@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 10:33 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 26 Nov 2008, Jan Scholz wrote:
>
>> Jiri Kosina <jkosina@suse.cz> writes:
>>
>> > On Wed, 26 Nov 2008, Jan Scholz wrote:
>> >
>> >> Changed HID_USB_DEVICE to HID_BLUETOOTH_DEVICE for the apple alu
>> >> wireless keyboards
>> >> Signed-off-by: Jan Scholz <Scholz@fias.uni-frankfurt.de>
>> >> ---
>> >>  drivers/hid/hid-apple.c |    6 +++---
>> >>  drivers/hid/hid-core.c  |    6 +++---
>> >>  2 files changed, 6 insertions(+), 6 deletions(-)
>> >>
>> >> diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
>> >> index 9b97795..aa28aed 100644
>> >> --- a/drivers/hid/hid-apple.c
>> >> +++ b/drivers/hid/hid-apple.c
>> >> @@ -400,12 +400,12 @@ static const struct hid_device_id apple_devices[] = {
>> >>    { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS),
>> >>            .driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
>> >>                    APPLE_RDESC_JIS },
>> >> -  { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI),
>> >> +  { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI),
>> >>            .driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
>> >> -  { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO),
>> >> +  { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO),
>> >>            .driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
>> >>                    APPLE_ISO_KEYBOARD },
>> >> -  { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS),
>> >> +  { HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS),
>> >>            .driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
>> >>    { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI),
>> >>            .driver_data = APPLE_HAS_FN },
>> >
>> > Hi Jan,
>> >
>> > shouldn't we rather have both USB and Bluetooth variants?
>> >
>> > Thanks,
>>
>> Hi Jiri,
>>
>> Hm, I thought the USB_DEVICE_ID_APPLE_ALU_{ANSI,ISO,JIS} were apples usb
>> aluminum keyboards (standard desktop size), while the
>> USB_DEVICE_ID_APPLE_ALU_WIRELESS_{ANSI,ISO,JIS} ones were the aluminum
>> bluetooth keyboards (notebook sized, no numeric keypad, etc).
>>
>> The one I own is a USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO, german layout,
>> with bluetooth, unfortunately I don't have access to a usb variant.
>
> Tobias Mueller added these device IDs, so persumably he has tested it and
> could provide some insight. I don't have the hardware myself, so I have no
> idea whether there are only Bluetooht variants, or even USB are available.

There is one bluetooth model and one USB model.

>
> Tobias?
>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

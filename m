Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYKZPSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYKZPSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYKZPSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:18:01 -0500
Received: from fias.uni-frankfurt.de ([141.2.248.1]:59214 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYKZPSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:18:00 -0500
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jan Scholz <Scholz@fias.uni-frankfurt.de>, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: Apple alu wireless keyboards are bluetooth devices
References: <1227710025-23592-1-git-send-email-Scholz@fias.uni-frankfurt.de>
	<1227710025-23592-2-git-send-email-Scholz@fias.uni-frankfurt.de>
	<alpine.LNX.1.10.0811261553010.19853@jikos.suse.cz>
Date: Wed, 26 Nov 2008 16:17:46 +0100
In-Reply-To: <alpine.LNX.1.10.0811261553010.19853@jikos.suse.cz> (Jiri
	Kosina's message of "Wed, 26 Nov 2008 15:54:06 +0100 (CET)")
Message-ID: <87ej0ywm79.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

> On Wed, 26 Nov 2008, Jan Scholz wrote:
>
>> Changed HID_USB_DEVICE to HID_BLUETOOTH_DEVICE for the apple alu
>> wireless keyboards
>> Signed-off-by: Jan Scholz <Scholz@fias.uni-frankfurt.de>
>> ---
>>  drivers/hid/hid-apple.c |    6 +++---
>>  drivers/hid/hid-core.c  |    6 +++---
>>  2 files changed, 6 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
>> index 9b97795..aa28aed 100644
>> --- a/drivers/hid/hid-apple.c
>> +++ b/drivers/hid/hid-apple.c
>> @@ -400,12 +400,12 @@ static const struct hid_device_id apple_devices[] = {
>>  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS),
>>  		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
>>  			APPLE_RDESC_JIS },
>> -	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI),
>> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI),
>>  		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
>> -	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO),
>> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO),
>>  		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
>>  			APPLE_ISO_KEYBOARD },
>> -	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS),
>> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS),
>>  		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
>>  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI),
>>  		.driver_data = APPLE_HAS_FN },
>
> Hi Jan,
>
> shouldn't we rather have both USB and Bluetooth variants?
>
> Thanks,

Hi Jiri,

Hm, I thought the USB_DEVICE_ID_APPLE_ALU_{ANSI,ISO,JIS} were apples usb
aluminum keyboards (standard desktop size), while the
USB_DEVICE_ID_APPLE_ALU_WIRELESS_{ANSI,ISO,JIS} ones were the aluminum
bluetooth keyboards (notebook sized, no numeric keypad, etc).

The one I own is a USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO, german layout,
with bluetooth, unfortunately I don't have access to a usb variant.

Jan

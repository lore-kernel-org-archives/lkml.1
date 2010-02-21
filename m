Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab0BUQHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:07:00 -0500
Received: from mx1.riseup.net ([204.13.164.18]:35137 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0BUQG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:06:58 -0500
X-Greylist: delayed 1229 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 11:06:58 EST
Message-ID: <4B81554F.40407@aktivix.org>
Date: Sun, 21 Feb 2010 15:46:23 +0000
From: Jim Dog <jimdog@aktivix.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: jimdog@northern-indymedia.org, gregkh@suse.de, jmm@debian.org,
       mithlesh@linsyssoft.com, richard@rsk.demon.co.uk,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wlan-ng: Fix 80 character limit warnings Fixed
 2 	warnings identified by the checkpatch.pl tool which occured due to two
 lines 	of code going over the 80 character limit. Fixed by wrapping the lines.
 	Signed-off-by: Jim Dog <jimdog@
References: <69e28c911002210706k1a5ae686r76df74a743dcce1c@mail.gmail.com>
In-Reply-To: <69e28c911002210706k1a5ae686r76df74a743dcce1c@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Not sure, guess that's why it's commented out. I just wrapped it so it
fitted in 80 chars.

JD

Gábor Stefanik wrote:
> On Sun, Feb 21, 2010 at 4:03 PM,  <jimdog@northern-indymedia.org> wrote:
>> From: Jim Dog <jimdog@northern-indymedia.org>
>>
>> ---
>>  drivers/staging/wlan-ng/prism2usb.c |    9 ++++++---
>>  1 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
>> index 9dde68b..b55930c 100644
>> --- a/drivers/staging/wlan-ng/prism2usb.c
>> +++ b/drivers/staging/wlan-ng/prism2usb.c
>> @@ -24,8 +24,9 @@ static struct usb_device_id usb_prism_tbl[] = {
>>         (0x066b, 0x2213, "Linksys WUSB12v1.1 11Mbps WLAN USB Adapter")},
>>        {PRISM_USB_DEVICE
>>         (0x067c, 0x1022, "Siemens SpeedStream 1022 11Mbps WLAN USB Adapter")},
>> -       {PRISM_USB_DEVICE(0x049f, 0x0033,
>> -                         "Compaq/Intel W100 PRO/Wireless 11Mbps multiport WLAN Adapter")},
>> +       {PRISM_USB_DEVICE
>> +        (0x049f, 0x0033,
>> +         "Compaq/Intel W100 PRO/Wireless 11Mbps multiport WLAN Adapter")},
>>        {PRISM_USB_DEVICE
>>         (0x0411, 0x0016, "Melco WLI-USB-S11 11Mbps WLAN Adapter")},
>>        {PRISM_USB_DEVICE
>> @@ -55,7 +56,9 @@ static struct usb_device_id usb_prism_tbl[] = {
>>         (0x04f1, 0x3009, "JVC MP-XP7250 Builtin USB WLAN Adapter")},
>>        {PRISM_USB_DEVICE(0x0846, 0x4110, "NetGear MA111")},
>>        {PRISM_USB_DEVICE(0x03f3, 0x0020, "Adaptec AWN-8020 USB WLAN Adapter")},
>> -/*      {PRISM_USB_DEVICE(0x0ace, 0x1201, "ZyDAS ZD1201 Wireless USB Adapter")}, */
>> +/*
>> +       {PRISM_USB_DEVICE(0x0ace, 0x1201, "ZyDAS ZD1201 Wireless USB Adapter")},
>> +*/
> 
> Why is this even included? We do have support for this in zd1201, and
> I'm pretty sure wlan-ng doesn't actually handle it.
> 
>>        {PRISM_USB_DEVICE(0x2821, 0x3300, "ASUS-WL140 Wireless USB Adapter")},
>>        {PRISM_USB_DEVICE(0x2001, 0x3700, "DWL-122 Wireless USB Adapter")},
>>        {PRISM_USB_DEVICE
>> --
>> 1.6.3.3
>>
>> _______________________________________________
>> devel mailing list
>> devel@linuxdriverproject.org
>> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>>
> 
> 
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkuBVUAACgkQjI3ttaQQxva7ywCgtB2/cbd+Tz+4WvvlyIGKwiFq
o6kAnjIu9lCZeIEb374pfZRoEU3G9oQx
=TKK4
-----END PGP SIGNATURE-----

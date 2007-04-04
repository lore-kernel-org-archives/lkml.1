Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbXDDNhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbXDDNhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 09:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbXDDNhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 09:37:19 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:43978 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbXDDNhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 09:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n6kzFEEeAdHvugrZtlF5aysSF5IvnE3RX1fXToUNfU2QwTZOtTkJfkyw1GGEx1b5GkkJrslaeZ9QwUVQzA+LEtXo8HKr0SedHZ5ofkYdiRtvvLXx2Y3zZoMgwC26jKC942OoEnT0yk0KgCiGPLsNsQFDcMT4x+dGrzCZp6ZR0bA=
Message-ID: <f9be06770704040637k419a7fd7t2cdd52186d91ad5f@mail.gmail.com>
Date: Wed, 4 Apr 2007 09:37:14 -0400
From: "Karl Pickett" <karl.pickett@gmail.com>
To: "Vincent Vanackere" <vincent.vanackere@gmail.com>
Subject: Re: [PATCH] Make ati_remote button repeat sensitivity soft-configurable
Cc: Eric.Piel@tremplin-utc.net, linux-kernel@vger.kernel.org,
       inux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <65258a580704040145m6eb7108frfa8197d3b88e207a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f9be06770704031734k11ec894fpdf1afe385108aece@mail.gmail.com>
	 <461357D8.8060608@tremplin-utc.net>
	 <65258a580704040145m6eb7108frfa8197d3b88e207a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is some more output...

[300950.438977] drivers/usb/input/ati_remote.c: Registered USB driver
ATI/X10 RF USB Remote Control v. 2.2.1
[300950.445902] drivers/usb/input/ati_remote.c: Weird data, len=1 ff
54 1f 60 13 20 ... (I only get that once, at startup)

Bus 001 Device 002: ID 0bc7:0004 X10 Wireless Technology, Inc. X10 Receiver
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x0bc7 X10 Wireless Technology, Inc.
  idProduct          0x0004 X10 Receiver
  bcdDevice            1.00
  iManufacturer           1
  iProduct                2
  iSerial                 0
  bNumConfigurations      1

This is me holding down a button with debug on:
Apr  4 09:27:32 karl-desktop kernel: [346509.808778] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346509.856726] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346509.896685] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346509.944634] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346509.984587] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346510.032540] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346510.072499] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346510.120453] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346510.160414] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346510.208361] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346510.248318] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346510.296264] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346510.336222] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346510.384175] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:32 karl-desktop kernel: [346510.424135] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106
Apr  4 09:27:33 karl-desktop kernel: [346510.472085] ati_remote
1-1:1.0: channel 0x06; data 54,1f; index 41; keycode 106

That's .23 seconds between the first and 6th event.  A little quick :)
 I think the ideal fix would be a second timestamp that keeps track of
when the first event happened... not just the last event.  That way
you can set a real "don't repeat until after .5 seconds" option.







On 4/4/07, Vincent Vanackere <vincent.vanackere@gmail.com> wrote:
> On 4/4/07, Éric Piel <Eric.Piel@tremplin-utc.net> wrote:
>
> > This default value is set to 300 ms. On my Xserver, the default value is
> > 660 ms and by default in my distrib it's set to 500 ms. So, indeed, the
> > default value of the ati_remote is quite small. Maybe you could increase
> > FILTER_MAX to 10 (= 600 ms) in order to have something saner?
>
> Well, this value was chosen because it matches what the hardware does
> : as explained in the comments, the hardware generates exactly 5
> events for the first keypress (spaced by ~50ms if I recall correctly).
>
> At least on my hardware (=> Vendor=0bc7 ProdID=0004 Rev= 1.00), the
> current default value match exactly what I'm expecting (never had the
> problem : "if you do anything but barely tap the button you can get
> multiple events reported").
> Just a thought : perhaps some models are more sensitive than others
> (and so the default should be made dependent on the exact remote
> model)... what is your hardware id ?
>
> Best regards,
>
> Vincent
>


-- 
Karl Pickett
The most wasted of all days is one without laughter.—E.E. Cummings

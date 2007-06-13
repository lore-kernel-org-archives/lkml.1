Return-Path: <linux-kernel-owner+w=401wt.eu-S1758430AbXFMOJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430AbXFMOJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 10:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXFMOJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 10:09:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:35635 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbXFMOJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 10:09:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gR/pWG6TFyF6CS5dionMDyKwMGVb2hVlUM+wHFUxJmorOHgQzVMkp6yGK4VnP8h8uIf8tHKSYreec6vit6Wg2MT1JZvxj64o7waeZlEGwr44JSTM5vucjxnH+gnXnL33kGOsdcM7o5ShuTVB6mc1b+aHigKRhXbosIZFEZTupgg=
Subject: Re: USB remote control missing keycodes
From: Islam Amer <pharon@gmail.com>
Reply-To: pharon@gmail.com
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706111656340.23280@twin.jikos.cz>
References: <20070611101319.GA14284@DervishD>  <466D2DF7.9020709@aladin.ro>
	 <1181563063.19258.11.camel@iamer-laptop>
	 <Pine.LNX.4.64.0706111656340.23280@twin.jikos.cz>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 17:08:54 +0300
Message-Id: <1181743734.6163.1.camel@iamer-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-11 at 17:02 +0200, Jiri Kosina wrote:
> On Mon, 11 Jun 2007, Islam Amer wrote:
> 
> > I have a remote control device, with an IR transciever that plugs into a 
> > USB port and registers as an input device. All the buttons on the remote 
> > work fine except for the back , text , and three grey buttons at the 
> > top.
> 
> Could you please recompile your kernel with CONFIG_HID_DEBUG (2.6.21-rc1 
> or any newer) and send me the output both from the time you connect the 
> device in the USB port, and also when you press the non-functional keys?
> 
> Thanks,
> 

Sorry for the late reply, here's the output I got with 2.6.21.4 and
CONFIG_HID_DEBUG ..

[  706.108243] usb 1-3: new low speed USB device using ohci_hcd and
address 2
[  706.321518] PM: Adding info for usb:1-3
[  706.321616] PM: Adding info for No Bus:usbdev1.2_ep00
[  706.321642] usb 1-3: configuration #1 chosen from 1 choice
[  706.324518] PM: Adding info for usb:1-3:1.0
[  706.337449] drivers/usb/input/hid-core.c: report descriptor (size
246, read 246) =  15 00 25 01 05 01 09 80 a1 01 85 01 19 81 29 83 75 01
95 03 81 02 75 05 95 01 81 01 c0 05 0c 09 01 a1 01 85 04 19 00 2a f5 00
0a 09 02 0a 30 02 0a 2d 02 0a 2e 02 0a 24 02 15 00 26 f9 00 75 08 95 01
81 00 c0 05 01 09 02 a1 01 85 03 09 01 a1 00 05 09 19 01 29 03 15 00 25
01 75 01 95 03 81 02 75 05 95 01 81 01 05 01 09 30 09 31 15 81 25 7f 75
08 95 02 81 06 09 38 95 01 81 06 c0 c0 05 01 09 06 a1 01 85 02 05 07 19
e0 29 e7 15 00 25 01 75 01 95 08 81 02 19 00 2a ff 00 15 00 26 ff 00 75
08 95 03 81 00 05 08 25 01 19 01 29 05 75 01 95 05 91 02 75 03 95 01 91
01 c0 06 bc ff 09 88 a1 01 85 05 19 00 29 f0 15 00 26 f0 00 75 08 95 01
81 00 c0 06 80 ff 09 00 a1 01 85 06 75 08 95 04 15 00 26 ff 00 09 01 b1
82 09 01 81 82 95 07 09 02 91 82 c0

vol+ ( works )

[  764.661651] drivers/hid/hid-core.c: report (size 5) (numbered)
[  764.661659] drivers/hid/hid-core.c: report 4 (size 4) =  e9 00 00 00
[  764.661667] hid-debug: input Consumer.0000 = 0
[  764.661675] hid-debug: input Consumer.00e9 = 1
[  764.669634] drivers/hid/hid-core.c: report (size 5) (numbered)
[  764.669642] drivers/hid/hid-core.c: report 6 (size 4) =  01 90 00 00
[  764.669653] hid-debug: input ff80.0001 = 1
[  764.669685] hid-debug: input ff80.0001 = 144
[  764.669694] hid-debug: input ff80.0001 = 0
[  764.669701] hid-debug: input ff80.0001 = 0
[  764.781267] drivers/hid/hid-core.c: report (size 5) (numbered)
[  764.781275] drivers/hid/hid-core.c: report 4 (size 4) =  00 00 00 00
[  764.781284] hid-debug: input Consumer.00e9 = 0
[  764.781306] hid-debug: input Consumer.0000 = 1

vol- ( works )

[  991.475577] drivers/hid/hid-core.c: report (size 5) (numbered)
[  991.475583] drivers/hid/hid-core.c: report 4 (size 4) =  ea 00 00 00
[  991.475592] hid-debug: input Consumer.0000 = 0
[  991.475600] hid-debug: input Consumer.00ea = 1
[  991.483553] drivers/hid/hid-core.c: report (size 5) (numbered)
[  991.483561] drivers/hid/hid-core.c: report 6 (size 4) =  01 91 00 00
[  991.483572] hid-debug: input ff80.0001 = 1
[  991.483588] hid-debug: input ff80.0001 = 145
[  991.483605] hid-debug: input ff80.0001 = 0
[  991.483613] hid-debug: input ff80.0001 = 0
[  991.595188] drivers/hid/hid-core.c: report (size 5) (numbered)
[  991.595196] drivers/hid/hid-core.c: report 4 (size 4) =  00 00 00 00
[  991.595204] hid-debug: input Consumer.00ea = 0
[  991.595225] hid-debug: input Consumer.0000 = 1



back ( not working )

[  829.897373] drivers/hid/hid-core.c: report (size 5) (numbered)
[  829.897380] drivers/hid/hid-core.c: report 4 (size 4) =  fa 00 00 00
[  829.897389] hid-debug: input Consumer.0000 = 0
[  829.905338] drivers/hid/hid-core.c: report (size 5) (numbered)
[  829.905343] drivers/hid/hid-core.c: report 6 (size 4) =  01 23 00 00
[  829.905350] hid-debug: input ff80.0001 = 1
[  829.905360] hid-debug: input ff80.0001 = 35
[  829.905373] hid-debug: input ff80.0001 = 0
[  829.905383] hid-debug: input ff80.0001 = 0
[  830.001028] drivers/hid/hid-core.c: report (size 5) (numbered)
[  830.001033] drivers/hid/hid-core.c: report 6 (size 4) =  01 23 00 00
[  830.001039] hid-debug: input ff80.0001 = 1
[  830.001047] hid-debug: input ff80.0001 = 35
[  830.001053] hid-debug: input ff80.0001 = 0
[  830.001058] hid-debug: input ff80.0001 = 0
[  830.128620] drivers/hid/hid-core.c: report (size 5) (numbered)
[  830.128626] drivers/hid/hid-core.c: report 4 (size 4) =  00 00 00 00
[  830.128633] hid-debug: input Consumer.0000 = 1

txt ( not working )

[  900.156751] drivers/hid/hid-core.c: report (size 5) (numbered)
[  900.156762] drivers/hid/hid-core.c: report 5 (size 4) =  5a 00 00 00
[  900.156771] hid-debug: input ffbc.0000 = 0
[  900.156781] hid-debug: input ffbc.005a = 1
[  900.164708] drivers/hid/hid-core.c: report (size 5) (numbered)
[  900.164713] drivers/hid/hid-core.c: report 6 (size 4) =  01 aa 00 00
[  900.164725] hid-debug: input ff80.0001 = 1
[  900.164734] hid-debug: input ff80.0001 = 170
[  900.164748] hid-debug: input ff80.0001 = 0
[  900.164755] hid-debug: input ff80.0001 = 0
[  900.276344] drivers/hid/hid-core.c: report (size 5) (numbered)
[  900.276349] drivers/hid/hid-core.c: report 5 (size 4) =  00 00 00 00
[  900.276355] hid-debug: input ffbc.005a = 0
[  900.276362] hid-debug: input ffbc.0000 = 1

Thank you :)


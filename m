Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbYAIBNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbYAIBNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbYAIBMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:12:49 -0500
Received: from bossdog.realss.com ([211.157.108.128]:58360 "EHLO
	bossdog.realss.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYAIBMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:12:47 -0500
Subject: Re: Huawei EC321 CDMA PCCARD support broken
From: =?UTF-8?Q?=E5=BC=A0=E9=9F=A1=E6=AD=A6?= <zhangweiwu@realss.com>
To: Matthias Urlichs <smurf@smurf.noris.de>
Cc: linux-kernel@vger.kernel.org, hugh@blemings.org
In-Reply-To: <20080108062739.GO22955@kiste.smurf.noris.de>
References: <1199753931.6093.7.camel@Cruella>
	 <20080108062739.GO22955@kiste.smurf.noris.de>
Content-Type: text/plain; charset=utf-8
Organization: Real Softservice
Date: Wed, 09 Jan 2008 09:12:04 +0800
Message-Id: <1199841125.6440.4.camel@Cruella>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2008-01-08二的 07:27 +0100，Matthias Urlichs写道：
> Hi,
> > A lot of google searches reflect that, the latest kernel supporting
> > Huawei EC321 CDMA PCCARD is 2.6.17. My version (2.6.22-14 on Ubuntu)
> > doesn't work.
> > 
> This is probably because ...
> 
> > [ 3804.140000] /build/buildd/linux-source-2.6.22-2.6.22/drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
> 
> ... the card is in fact recognized by the pl2303 driver instead of the
> Option driver. This driver may do something stupid.
> 
> Please try this (as root):
> # rmmod plc2303
> # modprobe option

I did 'rmmod pl2302' because I could not find plc2303 module. The drect
result of above two commands, is /dev/ttyUSB0 disappeared.

WvDial<*1>: WvDial: Internet dialer version 1.56
WvDial<Err>: Cannot open /dev/ttyUSB0: No such file or directory
WvDial<Err>: Cannot open /dev/ttyUSB0: No such file or directory
WvDial<Err>: Cannot open /dev/ttyUSB0: No such file or directory

> 
> If the card still does not work, type
> # lsusb


Bus 008 Device 001: ID 0000:0000  
Bus 007 Device 001: ID 0000:0000  
Bus 006 Device 004: ID 12d1:1001  
Bus 006 Device 001: ID 0000:0000  
Bus 005 Device 001: ID 0000:0000  
Bus 004 Device 001: ID 0000:0000  
Bus 001 Device 004: ID 15d9:0a37  
Bus 001 Device 001: ID 0000:0000  
Bus 002 Device 001: ID 0000:0000  
Bus 003 Device 002: ID 05c6:3100 Qualcomm, Inc. CDMA Wireless
Modem/Phone
Bus 003 Device 001: ID 0000:0000  

FYI: the product is by Huawei, not by Qualcomm, Inc. Though I am not
sure if they rebranded it, but Huawei is one of the biggest manufacturer
in China and is likely to have their own product/chips.


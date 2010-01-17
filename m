Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756Ab0AQP2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab0AQP2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174Ab0AQP2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:28:53 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:34553 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0AQP2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:28:52 -0500
Message-ID: <4B532CB7.4060005@pardus.org.tr>
Date: Sun, 17 Jan 2010 17:28:55 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: =?UTF-8?B?Q2VuZ2l6IEfDvG5heQ==?= <cgunay@emory.edu>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: sata_nv times out for BD-ROM iHOS104-08
References: <Pine.LNX.4.64.0912221105010.5876@stg.biology.emory.edu> 	<4B31C8EE.3030003@kernel.org> <d2d378040912232302u4b550dap687fcadced237935@mail.gmail.com> 	<4B331771.3090309@kernel.org> <d2d378041001161334r6fe3ee65w39cf98a6c2d1d399@mail.gmail.com>
In-Reply-To: <d2d378041001161334r6fe3ee65w39cf98a6c2d1d399@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cengiz Günay wrote:
> 2009/12/24 Tejun Heo <tj@kernel.org>:
>> I don't think the controller has anything to do with the issue but
>> just in case can you please try it with a different controller?
> 
> I tried the iHOS BD-ROM with a VIA VT6412 SATA controller today and it worked:
> 

I don't have the possibility to try with another controller but exactly the same issue with PIONEER DVD-RW DVRKD08RS:

[    4.618380] ata1.00: ATAPI: PIONEER DVD-RW DVRKD08RS, 1.02, max UDMA/33      
[    4.618447] ata1: nv_mode_filter: 0x739f&0x739f->0x739f, BIOS=0x7000 (0xc000c700) ACPI=0x701f (60:600:0x13)                                                  
[    4.625131] ata1.00: configured for UDMA/33                                  
[    4.625214] ata1.00: TEST_UNIT_READY failed (err_mask=0x2)                   
[    4.838039] usb 3-2: new low speed USB device using ohci_hcd and address 2   
[    4.909709] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input6 
[    4.944821] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input7                                                                   
[    5.000029] Clocksource tsc unstable (delta = -254057140 ns)                 
[    5.027063] usb 3-2: New USB device found, idVendor=05e3, idProduct=1205     
[    5.027071] usb 3-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.027078] usb 3-2: Product: USB Mouse                                      
[    5.027199] usb 3-2: configuration #1 chosen from 1 choice                   
[    5.037758] input: USB Mouse               as /devices/pci0000:00/0000:00:02.0/usb3/3-2/3-2:1.0/input/input8                                                 
[    5.037936] generic-usb 0003:05E3:1205.0001: input,hidraw0: USB HID v1.10 Mouse [USB Mouse              ] on usb-0000:00:02.0-2/input0                       
[    5.708253] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f7cba403d32]  
[    9.769407] ata1: nv_mode_filter: 0x739f&0x739f->0x739f, BIOS=0x7000 (0xc000c700) ACPI=0x701f (60:600:0x13)                                                  
[    9.775326] ata1.00: configured for UDMA/33                                  
[    9.775408] ata1.00: TEST_UNIT_READY failed (err_mask=0x2)                   
[    9.775417] ata1.00: limiting speed to UDMA/33:PIO3                          
[   14.920401] ata1: nv_mode_filter: 0x738f&0x739f->0x738f, BIOS=0x7000 (0xc000c700) ACPI=0x701f (60:600:0x13)                                                  
[   14.926332] ata1.00: configured for UDMA/33                                  
[   14.926412] ata1.00: TEST_UNIT_READY failed (err_mask=0x2)                   
[   14.926418] ata1.00: disabled                                                
[   14.926452] ata1: soft resetting link                                        
[   15.077100] ata1: EH complete                                                
[   15.077155] ata2: port disabled. ignoring.

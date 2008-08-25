Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYHYRuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYHYRuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYHYRuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:50:06 -0400
Received: from n6.bullet.mail.ac4.yahoo.com ([76.13.13.234]:25949 "HELO
	n6.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752835AbYHYRuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:50:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 109018.62812.bm@omp104.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=Jx/rII1Xjj2arG/zAyBvQ+CCKNCGaFkpWZiKoksgJzWMrZgh9u4syvdaJw8fCS+sez+OHKukziZbZOFKLVYgztdSqdb783Ge28328cJDf1doqHWOfh7PVe7wzk7csFamWBPsDKRhJjljcnsifvEE93cOJiqjt8CIsWtBYowuW+s=;
X-Mailer: YahooMailWebService/0.7.218.2
Date: Mon, 25 Aug 2008 10:50:01 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: USB Serial device disconnect causes IRQ disable not working after patch
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <685308.61820.qm@web45211.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <334606.17794.qm@web45209.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Alan
The patch suggested by you did not work. I tried in another computer and found same issue. I have detailed log below.


[   44.761371] uhci_hcd 0000:00:1d.1: release dev 3 ep81-INT, period 8, phase 4, 93 us
[   46.568107] uhci_hcd 0000:00:1d.1: reserve dev 3 ep81-INT, period 8, phase 4, 93 us
[   46.569949] uhci_hcd 0000:00:1d.1: release dev 3 ep81-INT, period 8, phase 4, 93 us
[   46.570174] uhci_hcd 0000:00:1d.1: reserve dev 3 ep81-INT, period 8, phase 4, 93 us
[   46.570942] uhci_hcd 0000:00:1d.1: release dev 3 ep81-INT, period 8, phase 4, 93 us
[   47.576006] uhci_hcd 0000:00:1d.1: reserve dev 3 ep81-INT, period 8, phase 4, 93 us
[  112.460694] usbserial: USB Serial support registered for Magtek 75/Excella USB card reader
[  112.462710] usbcore: registered new interface driver magtek
[  112.463185] magtek: v1.01 Amruth Vamadev
[  112.463192] magtek: MAGTEK 75/Excella check USB Chipcard Reader Driver
[  143.041808] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0002
[  143.041808] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[  143.041808] hub 1-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
[  143.168024] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
[  143.224309] ehci_hcd 0000:00:1d.7: port 1 high speed
[  143.224323] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[  143.280021] usb 1-1: new high speed USB device using ehci_hcd and address 4
[  143.336281] ehci_hcd 0000:00:1d.7: port 1 high speed
[  143.336292] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[  143.412650] usb 1-1: default language 0x0409
[  143.413121] usb 1-1: uevent
[  143.417056] usb 1-1: usb_probe_device
[  143.417068] usb 1-1: configuration #1 chosen from 1 choice
[  143.417361] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[  143.417422] usb 1-1:1.0: uevent
[  143.417622] usbserial_generic 1-1:1.0: usb_probe_interface
[  143.417627] usbserial_generic 1-1:1.0: usb_probe_interface - got id
[  143.417646] magtek 1-1:1.0: usb_probe_interface
[  143.417650] magtek 1-1:1.0: usb_probe_interface - got id
[  143.417659] magtek 1-1:1.0: Magtek 75/Excella USB card reader converter detected
[  143.417669] drivers/usb/serial/magtek.c: magtek_startup
[  143.417800] usb 1-1: link qh0-00ff/df91b100 start 0 [1/0 us]
[  143.417865] drivers/usb/serial/magtek.c: magtek_startup - usb_submit_urb(int urb)
[  143.418108] usb 1-1: Magtek 75/Excella USB card reader converter now attached to ttyUSB0
[  143.418874] drivers/usb/core/inode.c: creating file '004'
[  143.419046] usb 1-1: New USB device found, idVendor=0801, idProduct=2231
[  143.419052] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  143.419056] usb 1-1: Product: STX
[  143.419059] usb 1-1: Manufacturer: MagTek
[  143.419062] usb 1-1: SerialNumber: STX001
[  148.765273] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[  148.765273] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[  148.765273] hub 1-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
[  148.892021] hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
[  148.948172] ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
[  148.948184] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
[  148.948201] usb usb2: wakeup_rh (auto-start)
[  148.948222] hub 1-0:1.0: port 2 not reset yet, waiting 50ms
[  149.004019] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[  149.004054] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
[  149.004065] uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
[  149.004075] hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[  149.132021] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[  149.244042] usb 2-2: new full speed USB device using uhci_hcd and address 2
[  149.376015] usb 2-2: ep0 maxpacket = 8
[  149.399097] usb 2-2: default language 0x0409
[  149.408004] usb 2-2: uevent
[  149.418007] usb 2-2: usb_probe_device
[  149.418019] usb 2-2: configuration #1 chosen from 1 choice
[  149.421042] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[  149.421112] usb 2-2:1.0: uevent
[  149.421158] usbserial_generic 2-2:1.0: usb_probe_interface
[  149.421163] usbserial_generic 2-2:1.0: usb_probe_interface - got id
[  149.421182] magtek 2-2:1.0: usb_probe_interface
[  149.421186] magtek 2-2:1.0: usb_probe_interface - got id
[  149.421193] magtek 2-2:1.0: Magtek 75/Excella USB card reader converter detected
[  149.421201] drivers/usb/serial/magtek.c: magtek_startup
[  149.421219] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 61 us
[  149.421224] drivers/usb/serial/magtek.c: magtek_startup - usb_submit_urb(int urb)
[  149.421453] usb 2-2: Magtek 75/Excella USB card reader converter now attached to ttyUSB1
[  149.421595] drivers/usb/core/inode.c: creating file '002'
[  149.421662] usb 2-2: New USB device found, idVendor=0801, idProduct=000a
[  149.421668] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  149.421672] usb 2-2: Product: IntelliStripe 65
[  149.421675] usb 2-2: Manufacturer: MagTek
[  149.421683] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[  167.564004] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0002
[  167.564004] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001002 POWER sig=se0 CSC
[  167.564004] hub 1-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
[  167.564004] usb 1-1: USB disconnect, address 4
[  167.564004] usb 1-1: unregistering device
[  167.564004] usb 1-1: usb_disable_device nuking all URBs
[  167.564004] usb 1-1: unlink qh0-00ff/df91b100 start 0 [1/0 us]
[  167.564004] drivers/usb/serial/magtek.c: magtek_read_int_callback - port 0
[  167.564004] ehci_hcd 0000:00:1d.7: shutdown urb df794600 ep2in-intr
[  167.564004] usb 1-1: unregistering interface 1-1:1.0
[  167.564004] drivers/usb/serial/magtek.c: magtek_shutdown
[  167.571167] magtek ttyUSB0: Magtek 75/Excella USB card reader converter now disconnected from ttyUSB0
[  167.571226] magtek 1-1:1.0: device disconnected
[  167.571241] usb 1-1:1.0: uevent
[  167.571640] usb 1-1: uevent
[  167.696020] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
[  170.949363] usb 2-2: uhci_result_common: failed with status 440000
[  170.949363] drivers/usb/serial/magtek.c: magtek_read_int_callback - port 1
[  170.949363] uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 8, phase 4, 61 us
[  171.024049] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
[  171.024068] uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
[  171.024083] hub 2-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
[  171.024089] usb 2-2: USB disconnect, address 2
[  171.024092] usb 2-2: unregistering device
[  171.024096] usb 2-2: usb_disable_device nuking all URBs
[  171.024105] usb 2-2: unregistering interface 2-2:1.0
[  171.024196] drivers/usb/serial/magtek.c: magtek_shutdown
[  171.028630] magtek ttyUSB1: Magtek 75/Excella USB card reader converter now disconnected from ttyUSB1
[  171.028695] magtek 2-2:1.0: device disconnected
[  171.028710] usb 2-2:1.0: uevent
[  171.029093] usb 2-2: uevent
[  171.156020] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
[  172.512024] usb usb2: suspend_rh (auto-stop)
[  175.874728] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[  175.874728] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[  175.874728] hub 1-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
[  176.004020] hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
[  176.060196] ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
[  176.060207] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
[  176.060222] usb usb2: wakeup_rh (auto-start)
[  176.060235] hub 1-0:1.0: port 2 not reset yet, waiting 50ms
[  176.116022] ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
[  176.116057] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
[  176.116068] uhci_hcd 0000:00:1d.0: port 2 portsc 0093,00
[  176.116078] hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[  176.244020] hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[  176.356016] usb 2-2: new full speed USB device using uhci_hcd and address 3
[  176.488015] usb 2-2: ep0 maxpacket = 8
[  176.500004] usb 2-2: default language 0x0409
[  176.504004] usb 2-2: uevent
[  176.529878] usb 2-2: usb_probe_device
[  176.529887] usb 2-2: configuration #1 chosen from 1 choice
[  176.533029] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[  176.533102] usb 2-2:1.0: uevent
[  176.533148] usbserial_generic 2-2:1.0: usb_probe_interface
[  176.533153] usbserial_generic 2-2:1.0: usb_probe_interface - got id
[  176.533172] magtek 2-2:1.0: usb_probe_interface
[  176.533176] magtek 2-2:1.0: usb_probe_interface - got id
[  176.533183] magtek 2-2:1.0: Magtek 75/Excella USB card reader converter detected
[  176.533192] drivers/usb/serial/magtek.c: magtek_startup
[  176.533211] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 61 us
[  176.533217] drivers/usb/serial/magtek.c: magtek_startup - usb_submit_urb(int urb)
[  176.533438] usb 2-2: Magtek 75/Excella USB card reader converter now attached to ttyUSB0
[  176.533595] drivers/usb/core/inode.c: creating file '003'
[  176.533663] usb 2-2: New USB device found, idVendor=0801, idProduct=000a
[  176.533668] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  176.533672] usb 2-2: Product: IntelliStripe 65
[  176.533675] usb 2-2: Manufacturer: MagTek
[  176.533684] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0004
[  182.697945] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0002
[  182.697966] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
[  182.697980] hub 1-0:1.0: port 1, status 0501, change 0001, 480 Mb/s
[  182.824020] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
[  182.880323] ehci_hcd 0000:00:1d.7: port 1 high speed
[  182.880333] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[  182.936025] usb 1-1: new high speed USB device using ehci_hcd and address 7
[  182.992298] ehci_hcd 0000:00:1d.7: port 1 high speed
[  182.992312] ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
[  183.068539] usb 1-1: default language 0x0409
[  183.068999] usb 1-1: uevent
[  183.073134] usb 1-1: usb_probe_device
[  183.073148] usb 1-1: configuration #1 chosen from 1 choice
[  183.073452] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[  183.073511] usb 1-1:1.0: uevent
[  183.073580] usbserial_generic 1-1:1.0: usb_probe_interface
[  183.073585] usbserial_generic 1-1:1.0: usb_probe_interface - got id
[  183.073605] magtek 1-1:1.0: usb_probe_interface
[  183.073609] magtek 1-1:1.0: usb_probe_interface - got id
[  183.073617] magtek 1-1:1.0: Magtek 75/Excella USB card reader converter detected
[  183.073624] drivers/usb/serial/magtek.c: magtek_startup
[  183.073752] usb 1-1: link qh0-00ff/df91b080 start 0 [1/0 us]
[  183.076223] magtek:  usb_submit_urb(read int) failed
[  183.076231] drivers/usb/serial/magtek.c: magtek_startup - usb_submit_urb(int urb)
[  183.076461] usb 1-1: Magtek 75/Excella USB card reader converter now attached to ttyUSB1
[  183.076599] drivers/usb/core/inode.c: creating file '007'
[  183.076669] usb 1-1: New USB device found, idVendor=0801, idProduct=2231
[  183.076674] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  183.076678] usb 1-1: Product: STX
[  183.076681] usb 1-1: Manufacturer: MagTek
[  183.076684] usb 1-1: SerialNumber: STX001
[  185.704529] irq 23: nobody cared (try booting with the "irqpoll" option)
[  185.704529] Pid: 3505, comm: automount Not tainted 2.6.26-KGDB #1
[  185.704529]  [<c013fe84>] __report_bad_irq+0x2e/0x6f
[  185.704529]  [<c0140098>] note_interrupt+0x1d3/0x207
[  185.704529]  [<c013f60e>] ? handle_IRQ_event+0x21/0x48
[  185.704529]  [<c01407c0>] handle_fasteoi_irq+0x8a/0xaa
[  185.704529]  [<c01056f2>] do_IRQ+0x71/0x8b
[  185.704529]  [<c010416b>] common_interrupt+0x23/0x28
[  185.704529]  [<c012007b>] ? prof_cpu_mask_write_proc+0xf/0x2f
[  185.704529]  [<c0103747>] ? sysenter_past_esp+0x38/0x91
[  185.704529]  =======================
[  185.704529] handlers:
[  185.704529] [<c03428d9>] (usb_hcd_irq+0x0/0x58)


Thanks
Amruth p.v


--- On Thu, 8/21/08, amruth <amruth_pv@yahoo.com> wrote:

> From: amruth <amruth_pv@yahoo.com>
> Subject: USB Serial device disconnect causes IRQ disable details captured
> To: "Alan Stern" <stern@rowland.harvard.edu>
> Cc: "Oliver Neukum" <oliver@neukum.org>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Thursday, August 21, 2008, 4:52 PM
> Thanks Alan. I will test in another computers with the new
> patch and let you know if I again find the issue.
> 
> Thanks
> Amruth p.v
> 
> 
> --- On Thu, 8/21/08, Alan Stern
> <stern@rowland.harvard.edu> wrote:
> 
> > From: Alan Stern <stern@rowland.harvard.edu>
> > Subject: Re: USB Serial device disconnect causes IRQ
> disable details captured
> > To: "amruth" <amruth_pv@yahoo.com>
> > Cc: "Oliver Neukum"
> <oliver@neukum.org>, linux-usb@vger.kernel.org,
> linux-kernel@vger.kernel.org
> > Date: Thursday, August 21, 2008, 4:20 PM
> > On Thu, 21 Aug 2008, amruth wrote:
> > 
> > > Hi
> > > Oliver
> > > I got the same issue once again. I have captured
> > detail log and lusb -t with interrupts.
> > > cat /proc/interrupts:
> > 
> > > dmesg:
> > > sb 1-5: Magtek 75/Excella USB card reader
> converter
> > now attached to ttyUSB1
> > > drivers/usb/core/inode.c: creating file
> '012'
> > > usb 1-5: New USB device found, idVendor=0801,
> > idProduct=2231
> > > usb 1-5: New USB device strings: Mfr=1,
> Product=2,
> > SerialNumber=3
> > > usb 1-5: Product: STX
> > > usb 1-5: Manufacturer: MagTek
> > > usb 1-5: SerialNumber: STX001
> > > usb 2-2: uhci_result_common: failed with status
> 440000
> > >
> /home/amr/linux-2.6.26/drivers/usb/serial/magtek.c:
> > magtek_read_int_callback - p
> > > ort 0
> > > uhci_hcd 0000:00:1d.0: release dev 6 ep81-INT,
> period
> > 8, phase 4, 61 us
> > > hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
> > > uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
> > > hub 2-0:1.0: port 2, status 0100, change 0003, 12
> Mb/s
> > > usb 2-2: USB disconnect, address 6
> > > usb 2-2: unregistering device
> > > usb 2-2: usb_disable_device nuking all URBs
> > > usb 2-2: unregistering interface 2-2:1.0
> > >
> /home/amr/linux-2.6.26/drivers/usb/serial/magtek.c:
> > magtek_shutdown
> > > magtek ttyUSB0: Magtek 75/Excella USB card reader
> > converter now disconnected from ttyUSB0
> > > magtek 2-2:1.0: device disconnected
> > > usb 2-2:1.0: uevent
> > > usb 2-2: uevent
> > > hub 2-0:1.0: debounce: port 2: total 100ms stable
> > 100ms status 0x100
> > > usb usb2: suspend_rh (auto-stop)
> > > ehci_hcd 0000:00:1d.7: devpath 5 ep2in 3strikes
> > >
> /home/amr/linux-2.6.26/drivers/usb/serial/magtek.c:
> > magtek_read_int_callback - port 1
> > > usb 1-5: unlink qh0-00ff/dec56380 start 0 [1/0
> us]
> > > usb 1-5: link qh0-00ff/dec56380 start 0 [1/0 us]
> > > usb 1-5: unlink qh0-00ff/dec56380 start 0 [1/0
> us]
> > > ehci_hcd 0000:00:1d.7: HC died; cleaning up
> > 
> > You should try using the patch in this message:
> > 
> >
> 	http://marc.info/?l=linux-usb&m=121848784300960&w=2
> > 
> > If that doesn't help, can you test this on another
> > computer to see if
> > the same thing happens?
> > 
> > For future testing, it would help if you enable
> > CONFIG_PRINTK_TIME.
> > 
> > Alan Stern
> 
> 
>       
> 
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html


      


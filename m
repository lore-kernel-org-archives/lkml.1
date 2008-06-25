Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbYFYCFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbYFYCFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 22:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYFYCFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 22:05:23 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52925 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbYFYCFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 22:05:21 -0400
Date: Tue, 24 Jun 2008 19:05:13 -0700
From: Adam Williamson <awilliamson@mandriva.com>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26,
	prevents use of device
In-reply-to: <200806232041.09251.oliver@neukum.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org
Message-id: <1214359513.6054.63.camel@lenovo.local.net>
Organization: Mandriva
MIME-version: 1.0
X-Mailer: Evolution 2.22.2-3mdv2009.0
Content-type: multipart/mixed; boundary="=-LEs85ao2S7rZLTyz9ubA"
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
 <200806230948.03027.oliver@neukum.org>
 <1214236003.6054.6.camel@lenovo.local.net>
 <200806232041.09251.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LEs85ao2S7rZLTyz9ubA
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2008-06-23 at 20:41 +0200, Oliver Neukum wrote:

> It is the module option "debug" for usb-serial.

OK, here you go:
-- 
adamw

--=-LEs85ao2S7rZLTyz9ubA
Content-Disposition: attachment; filename=26_untainted_debug.txt
Content-Type: text/plain; name=26_untainted_debug.txt; charset=utf-8
Content-Transfer-Encoding: 7bit

usb 3-3: new full speed USB device using ohci_hcd and address 2
usb 3-3: configuration #1 chosen from 1 choice
usb 3-3: New USB device found, idVendor=03f0, idProduct=1016
usb 3-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: Had to override the open usb serial operation with the generic one.
drivers/usb/serial/usb-serial.c: Had to override the write usb serial operation with the generic one.
drivers/usb/serial/usb-serial.c: Had to override the close usb serial operation with the generic one.
drivers/usb/serial/usb-serial.c: Had to override the write_room usb serial operation with the generic one.
drivers/usb/serial/usb-serial.c: Had to override the chars_in_buffer usb serial operation with the generic one.
drivers/usb/serial/usb-serial.c: Had to override the read_bulk_callback usb serial operation with the generic one.
drivers/usb/serial/usb-serial.c: Had to override the write_bulk_callback usb serial operation with the generic one.
usbserial: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
drivers/usb/serial/usb-serial.c: Had to override the resume usb serial operation with the generic one.
usbserial: USB Serial support registered for PocketPC PDA
ipaq: USB PocketPC PDA driver v0.5
drivers/usb/serial/usb-serial.c: static descriptor matches
drivers/usb/serial/usb-serial.c: found bulk in on endpoint 0
drivers/usb/serial/usb-serial.c: found bulk out on endpoint 1
ipaq 3-3:1.0: PocketPC PDA converter detected
drivers/usb/serial/usb-serial.c: usb_serial_probe - setting up 2 port structures for this device
drivers/usb/serial/usb-serial.c: get_free_serial 2
drivers/usb/serial/usb-serial.c: get_free_serial - minor base = 0
drivers/usb/serial/usb-serial.c: usb_serial_probe - registering ttyUSB0
usb 3-3: PocketPC PDA converter now attached to ttyUSB0
drivers/usb/serial/usb-serial.c: usb_serial_probe - registering ttyUSB1
usb 3-3: PocketPC PDA converter now attached to ttyUSB1
usbcore: registered new interface driver ipaq
PPP generic driver version 2.4.2
drivers/usb/serial/usb-serial.c: serial_open
drivers/usb/serial/usb-serial.c: serial_open
BUG: unable to handle kernel NULL pointer dereference at 0000003c
IP: [<e0d878bd>] :ipaq:ipaq_open+0x1c4/0x2fb
*pde = 00000000
Oops: 0002 [#1]
Modules linked in: ppp_generic slhc ipaq usbserial fuse af_packet snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ipv6 binfmt_misc loop dm_mirror dm_log dm_mod floppy cpufreq_ondemand freq_table cpufreq_conservative cpufreq_powersave cpufreq_nforce2 evdev snd_mpu401 snd_cs4232 snd_opl3_lib snd_hwdep snd_cs4231_lib ns558 gameport snd_mpu401_uart parport_pc snd_rawmidi snd_seq_device parport rtc_cmos rtc_core rtc_lib sg snd_pcsp skge osst st thermal processor button usbkbd usbmouse usbhid ff_memless snd_intel8x0 snd_ac97_codec ac97_bus shpchp pci_hotplug snd_pcm snd_timer snd forcedeth i2c_nforce2 i2c_core soundcore nvidia_agp snd_page_alloc agpgart hid ide_generic amd74xx ide_core sbp2 ohci1394 ieee1394 usb_storage sata_sil pata_amd libata dock sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: nf_conntrack]

Pid: 4393, comm: pppd Not tainted (2.6.26-0.rc4.1mdv #1)
EIP: 0060:[<e0d878bd>] EFLAGS: 00010246 CPU: 0
EIP is at ipaq_open+0x1c4/0x2fb [ipaq]
EAX: 00000000 EBX: db368ca0 ECX: 00000000 EDX: db3a4000
ESI: 00000000 EDI: db235800 EBP: db3bbe3c ESP: db3bbe1c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process pppd (pid: 4393, ti=db3ba000 task=db140700 task.ti=db3ba000)
Stack: db368cb4 db0aa220 00000100 00000064 db235800 00000000 db235800 db0aa220
       db3bbe5c e0da0cd6 db2fb6c0 df9b0000 db235824 ffffffed e0da0bf7 db2fb6c0
       db3bbe84 c022549d 00000802 00000000 0bc00001 00000001 df9b0000 00000000
Call Trace:
 [<e0da0cd6>] ? serial_open+0xdf/0x13d [usbserial]
 [<e0da0bf7>] ? serial_open+0x0/0x13d [usbserial]
 [<c022549d>] ? tty_open+0x184/0x272
 [<c0173364>] ? chrdev_open+0x130/0x147
 [<c016f967>] ? __dentry_open+0x103/0x1f0
 [<c016fadb>] ? nameidata_to_filp+0x1f/0x33
 [<c0173234>] ? chrdev_open+0x0/0x147
 [<c017a8ba>] ? do_filp_open+0x338/0x6b1
 [<c016f733>] ? get_unused_fd_flags+0xc1/0xcb
 [<c016f77d>] ? do_sys_open+0x40/0xbc
 [<c016f83b>] ? sys_open+0x1e/0x26
 [<c010392f>] ? sysenter_past_esp+0x78/0xd9
 =======================
Code: 00 00 00 85 c0 89 87 94 00 00 00 75 16 89 d0 e8 d4 60 3e df c7 87 84 00 00 00 00 00 00 00 e9 11 01 00 00 8b 87 8c 00 00 00 31 f6 <89> 50 3c 8b 87 94 00 00 00 8b 97 9c 00 00 00 89 42 3c 8b 87 8c
EIP: [<e0d878bd>] ipaq_open+0x1c4/0x2fb [ipaq] SS:ESP 0068:db3bbe1c
---[ end trace bb86bb5b50c9ee22 ]---
drivers/usb/serial/usb-serial.c: serial_tiocmset - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5404
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
drivers/usb/serial/usb-serial.c: serial_open
drivers/usb/serial/usb-serial.c: serial_close - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 12 byte(s)
drivers/usb/serial/usb-serial.c: serial_tiocmset - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5404
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x80047437
drivers/usb/serial/usb-serial.c: serial_write - port 0, 45 byte(s)
drivers/usb/serial/usb-serial.c: serial_write - port 0, 37 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
padlock: VIA PadLock Hash Engine not detected.
PPP MPPE Compression module registered
PPP BSD Compression module registered
PPP Deflate Compression module registered
drivers/usb/serial/usb-serial.c: serial_write - port 0, 26 byte(s)
drivers/usb/serial/usb-serial.c: serial_write - port 0, 33 byte(s)
drivers/usb/serial/usb-serial.c: serial_write - port 0, 15 byte(s)
drivers/usb/serial/usb-serial.c: serial_write - port 0, 21 byte(s)
drivers/usb/serial/usb-serial.c: serial_write - port 0, 25 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 15 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 21 byte(s)
drivers/usb/serial/usb-serial.c: serial_write - port 0, 9 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 27 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
mppe_decomp_init[0]: unknown key length
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 33 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 53 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 44 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 44 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 44 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 44 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 44 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 44 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 84 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 44 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 85 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 48 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_write - port 0, 44 byte(s)
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
--=-LEs85ao2S7rZLTyz9ubA--


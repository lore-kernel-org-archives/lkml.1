Return-Path: <linux-kernel-owner+w=401wt.eu-S1762454AbYF0TbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762454AbYF0TbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 15:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757832AbYF0Ta4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 15:30:56 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:43875 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786AbYF0Tay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:30:54 -0400
Date: Fri, 27 Jun 2008 12:28:54 -0700
From: Adam Williamson <awilliamson@mandriva.com>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26,
	prevents use of device
In-reply-to: <200806251741.23589.oliver@neukum.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org
Message-id: <1214594934.6054.117.camel@lenovo.local.net>
Organization: Mandriva
MIME-version: 1.0
X-Mailer: Evolution 2.22.2-3mdv2009.0
Content-type: multipart/mixed; boundary="=-lToR0ihv6Tddg/0EdGGS"
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
 <200806232041.09251.oliver@neukum.org>
 <1214359513.6054.63.camel@lenovo.local.net>
 <200806251741.23589.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lToR0ihv6Tddg/0EdGGS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2008-06-25 at 17:41 +0200, Oliver Neukum wrote:
> Am Mittwoch 25 Juni 2008 04:05:13 schrieb Adam Williamson:
> > On Mon, 2008-06-23 at 20:41 +0200, Oliver Neukum wrote:
> > 
> > > It is the module option "debug" for usb-serial.
> > 
> > OK, here you go:
> 
> Please also set the debug module parameter for the ipaq module.

OK.
-- 
adamw

--=-lToR0ihv6Tddg/0EdGGS
Content-Disposition: attachment; filename=26_untainted_debug_debug.txt
Content-Type: text/plain; name=26_untainted_debug_debug.txt; charset=utf-8
Content-Transfer-Encoding: 7bit

usb 2-3: new full speed USB device using ohci_hcd and address 2
usb 2-3: configuration #1 chosen from 1 choice
usb 2-3: New USB device found, idVendor=03f0, idProduct=1016
usb 2-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
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
ipaq 2-3:1.0: PocketPC PDA converter detected
drivers/usb/serial/usb-serial.c: usb_serial_probe - setting up 2 port structures for this device
drivers/usb/serial/ipaq.c: ipaq_startup
drivers/usb/serial/usb-serial.c: get_free_serial 2
drivers/usb/serial/usb-serial.c: get_free_serial - minor base = 0
drivers/usb/serial/usb-serial.c: usb_serial_probe - registering ttyUSB0
usb 2-3: PocketPC PDA converter now attached to ttyUSB0
drivers/usb/serial/usb-serial.c: usb_serial_probe - registering ttyUSB1
usb 2-3: PocketPC PDA converter now attached to ttyUSB1
usbcore: registered new interface driver ipaq
PPP generic driver version 2.4.2
drivers/usb/serial/usb-serial.c: serial_open
drivers/usb/serial/ipaq.c: ipaq_open - port 0
drivers/usb/serial/usb-serial.c: serial_open
drivers/usb/serial/ipaq.c: ipaq_open - port 1
BUG: unable to handle kernel NULL pointer dereference at 0000003c
IP: [<e0d848bd>] :ipaq:ipaq_open+0x1c4/0x2fb
*pde = 00000000
Oops: 0002 [#1]
Modules linked in: ppp_generic slhc ipaq usbserial fuse af_packet snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss ipv6 snd_mixer_oss binfmt_misc loop dm_mirror dm_log dm_mod floppy cpufreq_ondemand freq_table cpufreq_conservative cpufreq_powersave cpufreq_nforce2 evdev sg ns558 snd_mpu401 gameport snd_cs4232 snd_opl3_lib snd_hwdep snd_cs4231_lib snd_mpu401_uart snd_rawmidi snd_seq_device skge parport_pc parport rtc_cmos rtc_core rtc_lib snd_pcsp thermal usbkbd usbmouse button processor usbhid ff_memless osst snd_intel8x0 snd_ac97_codec ac97_bus i2c_nforce2 shpchp st i2c_core pci_hotplug snd_pcm forcedeth snd_timer nvidia_agp snd soundcore snd_page_alloc agpgart hid ide_generic amd74xx ide_core sbp2 ohci1394 ieee1394 usb_storage sata_sil pata_amd libata dock sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: nf_conntrack]

Pid: 4396, comm: pppd Not tainted (2.6.26-0.rc4.1mdv #1)
EIP: 0060:[<e0d848bd>] EFLAGS: 00010246 CPU: 0
EIP is at ipaq_open+0x1c4/0x2fb [ipaq]
EAX: 00000000 EBX: db37ecc0 ECX: 00000000 EDX: db3ae000
ESI: 00000000 EDI: db305c00 EBP: db3a5e3c ESP: db3a5e1c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process pppd (pid: 4396, ti=db3a4000 task=db368560 task.ti=db3a4000)
Stack: db37ecd4 de25d7a0 00000100 00000064 db305c00 00000000 db305c00 de25d7a0
       db3a5e5c e0d9dcd6 db222b00 db35c800 db305c24 ffffffed e0d9dbf7 db222b00
       db3a5e84 c022549d 00000802 00000000 0bc00001 00000001 db35c800 00000000
Call Trace:
 [<e0d9dcd6>] ? serial_open+0xdf/0x13d [usbserial]
 [<e0d9dbf7>] ? serial_open+0x0/0x13d [usbserial]
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
Code: 00 00 00 85 c0 89 87 94 00 00 00 75 16 89 d0 e8 d4 90 3e df c7 87 84 00 00 00 00 00 00 00 e9 11 01 00 00 8b 87 8c 00 00 00 31 f6 <89> 50 3c 8b 87 94 00 00 00 8b 97 9c 00 00 00 89 42 3c 8b 87 8c
EIP: [<e0d848bd>] ipaq_open+0x1c4/0x2fb [ipaq] SS:ESP 0068:db3a5e1c
---[ end trace f1d563584ad865f1 ]---
drivers/usb/serial/usb-serial.c: serial_tiocmset - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5404
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/ipaq.c: ipaq_chars_in_buffer - queuelen 0
drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
drivers/usb/serial/usb-serial.c: serial_open
drivers/usb/serial/usb-serial.c: serial_close - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 6, data = 43 4c 49 45 4e 54
drivers/usb/serial/usb-serial.c: serial_write - port 0, 12 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 12, data = 43 4c 49 45 4e 54 53 45 52 56 45 52
drivers/usb/serial/usb-serial.c: serial_tiocmset - port 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5401
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x5404
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/ipaq.c: ipaq_chars_in_buffer - queuelen 0
drivers/usb/serial/usb-serial.c: serial_set_termios - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/ipaq.c: ipaq_chars_in_buffer - queuelen 0
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/usb-serial.c: serial_chars_in_buffer = port 0
drivers/usb/serial/ipaq.c: ipaq_chars_in_buffer - queuelen 0
drivers/usb/serial/usb-serial.c: serial_ioctl - port 0, cmd 0x80047437
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 37, data = 7e ff 7d 23 c0 21 7d 21 7d 20 7d 20 7d 2e 7d 22 7d 26 7d 20 7d 20 7d 20 7d 20 7d 27 7d 22 7d 28 7d 22 dd 31 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 46 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 46, data = 7e ff 7d 23 c0 21 7d 21 7d 21 7d 20 7d 34 7d 22 7d 26 7d 20 7d 20 7d 20 7d 20 7d 25 7d 26 3f f7 32 f7 7d 27 7d 22 7d 28 7d 22 a0 7d 5d 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 37 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 37, data = 7e ff 7d 23 c0 21 7d 22 7d 20 7d 20 7d 2e 7d 22 7d 26 7d 20 7d 20 7d 20 7d 20 7d 27 7d 22 7d 28 7d 22 e3 b2 7e
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 46, data = 7e ff 7d 23 c0 21 7d 22 7d 21 7d 20 7d 34 7d 22 7d 26 7d 20 7d 20 7d 20 7d 20 7d 25 7d 26 3f f7 32 f7 7d 27 7d 22 7d 28 7d 22 4b 7d 34 7e
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 16, data = 7e 80 fd 01 00 00 0a 12 06 00 00 00 01 26 10 7e
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 46, data = 7e 80 21 01 00 00 28 02 06 00 2d 0f 01 03 06 00 00 00 00 81 06 00 00 00 00 82 06 00 00 00 00 83 06 00 00 00 00 84 06 00 00 00 00 79 06 7e
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 21, data = 7e 80 57 01 00 00 0e 01 0a 86 f1 ae 7d 5e 6d d5 0b 64 a2 cb 7e
padlock: VIA PadLock Hash Engine not detected.
PPP MPPE Compression module registered
PPP BSD Compression module registered
PPP Deflate Compression module registered
drivers/usb/serial/usb-serial.c: serial_write - port 0, 26 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 26, data = 80 fd 01 01 00 15 12 06 00 00 00 00 1a 04 78 00 18 04 78 00 15 03 2f 95 5f 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 33 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 33, data = 80 21 01 01 00 1c 02 06 00 2d 0f 01 03 06 c0 a8 83 01 81 06 00 00 00 00 83 06 00 00 00 00 75 3d 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 15 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 15, data = 80 fd 04 00 00 0a 12 06 00 00 00 01 9d 8c 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 21 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 21, data = 80 21 04 00 00 10 82 06 00 00 00 00 84 06 00 00 00 00 b7 a2 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 26 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 26, data = c0 21 08 02 00 14 80 57 01 00 00 0e 01 0a 86 f1 ae 7d 5e 6d d5 0b 64 62 e6 7e
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 21, data = 7e 80 fd 04 01 00 0f 1a 04 78 00 18 04 78 00 15 03 2f a1 c3 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 15 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 15, data = 80 fd 01 02 00 0a 12 06 00 00 00 00 55 9a 7e
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 22, data = 7e 80 21 04 01 00 10 81 06 00 00 00 00 83 06 00 00 00 00 a2 71 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 21 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 21, data = 80 21 01 02 00 10 02 06 00 2d 0f 01 03 06 c0 a8 83 01 4f b2 7e
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 10, data = 7e 80 fd 01 01 00 04 bc 11 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 9 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 9, data = 80 fd 02 01 00 04 71 34 7e
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 34, data = 7e 80 21 01 01 00 1c 02 06 00 2d 0f 01 03 06 00 00 00 00 81 06 00 00 00 00 83 06 00 00 00 00 f1 ac 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 27 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 27, data = 80 21 03 01 00 16 03 06 c0 a8 83 81 81 06 c0 a8 83 01 83 06 c0 a8 83 01 2c 62 7e
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 16, data = 7e 80 fd 02 02 00 0a 12 06 00 00 00 00 3c ee 7e
mppe_decomp_init[0]: unknown key length
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 22, data = 7e 80 21 02 02 00 10 02 06 00 2d 0f 01 03 06 c0 a8 83 01 6e 28 7e
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 34, data = 7e 80 21 01 02 00 1c 02 06 00 2d 0f 01 03 06 c0 a8 83 81 81 06 c0 a8 83 01 83 06 c0 a8 83 01 a0 29 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 33 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 33, data = 80 21 02 02 00 1c 02 06 00 2d 0f 01 03 06 c0 a8 83 81 81 06 c0 a8 83 01 83 06 c0 a8 83 01 93 73 7e
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 280, data = 7e 21 45 00 01 13 00 00 00 00 80 11 f5 b0 c0 a8 83 81 ff ff ff ff 00 44 00 43 00 ff 00 00 01 08 06 00 12 34 56 78 00 06 00 00 c0 a8 83 81 00 00 00 00 00 00 00 00 00 00 00 00 00 53 45 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 63 82 53 63 35 01 08 37 01 0f ff 6d cb 7e
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 280, data = 7e 21 45 00 01 13 00 00 00 00 80 11 f5 b0 c0 a8 83 81 ff ff ff ff 00 44 00 43 00 ff 00 00 01 08 06 00 12 34 56 78 00 06 00 00 c0 a8 83 81 00 00 00 00 00 00 00 00 00 00 00 00 00 53 45 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 63 82 53 63 35 01 08 37 01 0f ff 6d cb 7e
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 280, data = 7e 21 45 00 01 13 00 00 00 00 80 11 f5 b0 c0 a8 83 81 ff ff ff ff 00 44 00 43 00 ff 00 00 01 08 06 00 12 34 56 78 00 06 00 00 c0 a8 83 81 00 00 00 00 00 00 00 00 00 00 00 00 00 53 45 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 63 82 53 63 35 01 08 37 01 0f ff 6d cb 7e
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 53, data = 7e 21 45 00 00 30 85 a1 40 00 80 06 ed 52 c0 a8 83 81 c0 a8 83 01 05 99 16 2f 84 bb 88 7c 00 00 00 00 70 02 80 00 52 4b 00 00 02 04 05 b4 01 01 04 02 d5 46 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 54 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 54, data = 7e 21 45 00 00 30 00 00 40 00 40 06 b2 f4 c0 a8 83 01 c0 a8 83 81 16 2f 05 99 d9 b4 51 1e 84 bb 88 7d 5d 70 12 16 d0 90 97 00 00 02 04 05 b4 01 01 04 02 c0 dc 7e
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 46, data = 7e 2f 45 00 00 28 85 a2 40 00 80 00 ed 59 c0 a8 83 81 c0 a8 83 01 05 99 16 2f 84 bb 88 7d 5d d9 b4 51 1f 50 10 80 00 54 2b 00 00 a2 e2 7e
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 12, data = 7e 2d 10 54 1f 00 00 00 00 e6 b4 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 44 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 44, data = 21 45 00 00 28 ef 15 40 00 40 06 c3 e6 c0 a8 83 01 c0 a8 83 81 16 2f 05 99 d9 b4 51 1f 84 bb 88 81 50 10 16 d0 bd 57 00 00 6d 46 7e
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 12, data = 7e 2d 1f e6 1a 6e 00 00 00 c4 76 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 44 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 44, data = 21 45 00 00 28 ef 16 40 00 40 06 c3 e5 c0 a8 83 01 c0 a8 83 81 16 2f 05 99 d9 b4 51 1f 84 bb 88 85 50 10 16 d0 bd 53 00 00 e0 0e 7e
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 118, data = 7e 2d 1f 19 db 28 00 00 00 04 15 40 04 11 0a 00 00 00 00 00 00 37 63 63 40 00 00 00 00 28 00 00 00 3c 00 00 00 50 00 00 00 00 00 00 00 50 00 6f 00 63 00 6b 00 65 00 74 00 5f 00 50 00 43 00 00 00 50 00 6f 00 63 00 6b 00 65 00 74 00 50 00 43 00 00 00 00 00 68 00 70 00 20 00 69 00 50 00 41 00 51 00 20 00 72 00 7a 00 31 00 37 00 31 00 35 00 00 00 bd 2a 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 44 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 44, data = 21 45 00 00 28 ef 17 40 00 40 06 c3 e4 c0 a8 83 01 c0 a8 83 81 16 2f 05 99 d9 b4 51 1f 84 bb 88 f3 50 10 16 d0 bc e5 00 00 19 f0 7e
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 53, data = 7e 21 45 00 00 30 85 a6 40 00 80 06 ed 4d c0 a8 83 81 c0 a8 83 01 05 9a 1d 0e 84 bc 75 10 00 00 00 00 70 02 80 00 5e d6 00 00 02 04 05 b4 01 01 04 02 4c d0 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 45 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 45, data = 21 45 00 00 28 00 00 40 00 40 06 b2 fc c0 a8 83 01 c0 a8 83 81 1d 0e 05 9a 00 00 00 00 84 bc 75 11 50 14 00 00 0b 87 00 00 7d 5d 00 7e
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 53, data = 7e 21 45 00 00 30 85 a7 40 00 80 06 ed 4c c0 a8 83 81 c0 a8 83 01 05 9a 1d 0e 84 bc 75 10 00 00 00 00 70 02 80 00 5e d6 00 00 02 04 05 b4 01 01 04 02 d7 05 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 45 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 45, data = 21 45 00 00 28 00 00 40 00 40 06 b2 fc c0 a8 83 01 c0 a8 83 81 1d 0e 05 9a 00 00 00 00 84 bc 75 11 50 14 00 00 0b 87 00 00 7d 5d 00 7e
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 53, data = 7e 21 45 00 00 30 85 a8 40 00 80 06 ed 4b c0 a8 83 81 c0 a8 83 01 05 9a 1d 0e 84 bc 75 10 00 00 00 00 70 02 80 00 5e d6 00 00 02 04 05 b4 01 01 04 02 27 5b 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 45 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 45, data = 21 45 00 00 28 00 00 40 00 40 06 b2 fc c0 a8 83 01 c0 a8 83 81 1d 0e 05 9a 00 00 00 00 84 bc 75 11 50 14 00 00 0b 87 00 00 7d 5d 00 7e
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 57, data = 7e 21 45 00 00 34 85 a9 00 00 80 11 2d 3c c0 a8 83 81 c0 a8 83 01 05 9b 00 35 00 20 11 e3 00 f8 01 00 00 01 00 00 00 00 00 00 06 69 73 61 74 61 70 00 00 01 00 01 a1 c6 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 84 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 84, data = 21 45 c0 00 50 71 16 00 00 40 01 81 03 c0 a8 83 01 c0 a8 83 81 03 03 85 02 00 00 00 00 45 00 00 34 85 a9 00 00 80 11 2d 3c c0 a8 83 81 c0 a8 83 01 05 9b 00 35 00 20 11 e3 00 f8 01 00 00 01 00 00 00 00 00 00 06 69 73 61 74 61 70 00 00 01 00 01 82 db 7e
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
drivers/usb/serial/ipaq.c: ipaq_read_bulk_callback - port 0
ipaq ttyUSB0: ipaq_read_bulk_callback - length = 53, data = 7e 21 45 00 00 30 85 aa 40 00 80 06 ed 49 c0 a8 83 81 c0 a8 83 01 05 9a 1d 0e 84 bc 75 10 00 00 00 00 70 02 80 00 5e d6 00 00 02 04 05 b4 01 01 04 02 00 f8 7e
drivers/usb/serial/usb-serial.c: serial_write - port 0, 45 byte(s)
drivers/usb/serial/ipaq.c: ipaq_write - port 0
ipaq ttyUSB0: ipaq_write_bulk - length = 45, data = 21 45 00 00 28 00 00 40 00 40 06 b2 fc c0 a8 83 01 c0 a8 83 81 1d 0e 05 9a 00 00 00 00 84 bc 75 11 50 14 00 00 0b 87 00 00 7d 5d 00 7e
drivers/usb/serial/ipaq.c: ipaq_write_bulk_callback - port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
--=-lToR0ihv6Tddg/0EdGGS--


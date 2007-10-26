Return-Path: <linux-kernel-owner+w=401wt.eu-S1762485AbXJZBiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762485AbXJZBiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXJZBhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:37:54 -0400
Received: from hartman.uits.indiana.edu ([129.79.1.194]:46694 "EHLO
	hartman.uits.indiana.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbXJZBhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:37:52 -0400
X-Greylist: delayed 2060 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 21:37:51 EDT
From: CSights <csights@fastmail.fm>
To: linux-kernel@vger.kernel.org
Subject: cannot "hibernate" if program being debugged in gdb is paused after SIGABRT in linux 2.6.23 (but can in 2.6.22.7)
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Date: Thu, 25 Oct 2007 21:03:27 -0400
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_fzTIHZVS1Wg5bPm"
Message-Id: <200710252103.27675.csights@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_fzTIHZVS1Wg5bPm
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi LKML,
	My computer running kernel 2.6.23 does not "hibernate" (suspend to disk using 
the kernel's methods) with a program (named stringTest) running in gdb, but 
has received a SIGABRT.
	The hibernate is successful when running kernel 2.6.22.7 !

Here is the message from gdb:

terminate called after throwing an instance of 'std::out_of_range'
  what():  basic_string::substr

Program received signal SIGABRT, Aborted.
0xb7fb6410 in __kernel_vsyscall ()

And the attached file is the portion of /var/log/syslog when the hibernate was 
attempted.

Let me know if there is anything else to send,
	C.

--Boundary-00=_fzTIHZVS1Wg5bPm
Content-Type: text/plain;
  charset="utf-8";
  name="attemptsuspend2disk-2"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="attemptsuspend2disk-2"

Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: INFO: Ev=
ent: GLOBAL_SUSPEND2DISK occured.
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: INFO: Pa=
rameters: Event - global.suspend2disk; Current Active Scheme: scheme_perfor=
mance - ACPI event line: empty
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 0
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: INFO: Ru=
nning get_kernels()
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 5|checking resume ke=
rnel
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: ru=
nning kernel: 2.6.23
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: WARNING:=
 no kernelfile matching the running kernel found
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 10|checking resume k=
ernel
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 15|checking for swap=
 partition
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 20
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 25|unmounting FAT/NT=
=46S partitions
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 30|stopping services
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 30|stopping service:=
 networking
Oct 25 14:59:04 comp_name dhclient: There is already a pid file /var/run/dh=
client.eth0.pid with pid 7818
Oct 25 14:59:04 comp_name dhclient: killed old client process, removed PID =
file
Oct 25 14:59:04 comp_name dhclient: Internet Systems Consortium DHCP Client=
 V3.0.6
Oct 25 14:59:04 comp_name dhclient: Copyright 2004-2007 Internet Systems Co=
nsortium.
Oct 25 14:59:04 comp_name dhclient: All rights reserved.
Oct 25 14:59:04 comp_name dhclient: For info, please visit http://www.isc.o=
rg/sw/dhcp/
Oct 25 14:59:04 comp_name dhclient:
Oct 25 14:59:04 comp_name dhclient: Listening on LPF/eth0/00:02:2d:31:b9:72
Oct 25 14:59:04 comp_name dhclient: Sending on   LPF/eth0/00:02:2d:31:b9:72
Oct 25 14:59:04 comp_name dhclient: Sending on   Socket/fallback
Oct 25 14:59:04 comp_name dhclient: DHCPRELEASE on eth0 to 192.168.1.100 po=
rt 67
Oct 25 14:59:04 comp_name kernel: eth0: New link status: Disconnected (0002)
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: Se=
rvice networking stopped
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 30|stopping service:=
 hdparm
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: Se=
rvice hdparm stopped
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 40|unloading modules
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 40|unloading module:=
 usb_storage
Oct 25 14:59:04 comp_name kernel: usbcore: deregistering interface driver u=
sb-storage
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 40|unloading module:=
 ohci_hcd
Oct 25 14:59:04 comp_name kernel: ohci_hcd 0000:00:02.1: remove, state 1
Oct 25 14:59:04 comp_name kernel: usb usb3: USB disconnect, address 1
Oct 25 14:59:04 comp_name kernel: usb 3-2: USB disconnect, address 2
Oct 25 14:59:04 comp_name kernel: ohci_hcd 0000:00:02.1: USB bus 3 deregist=
ered
Oct 25 14:59:04 comp_name kernel: ACPI: PCI interrupt for device 0000:00:02=
=2E1 disabled
Oct 25 14:59:04 comp_name kernel: ohci_hcd 0000:00:02.0: remove, state 1
Oct 25 14:59:04 comp_name kernel: usb usb1: USB disconnect, address 1
Oct 25 14:59:04 comp_name kernel: usb 1-2: USB disconnect, address 2
Oct 25 14:59:04 comp_name kernel: orinoco_usb: ezusb_bulk_in_callback: shor=
t read, ignoring
Oct 25 14:59:04 comp_name kernel: orinoco_usb: ezusb_submit_in_urb submit f=
ailed -19
Oct 25 14:59:04 comp_name kernel: orinoco_usb: Disconnected
Oct 25 14:59:04 comp_name kernel: ohci_hcd 0000:00:02.0: USB bus 1 deregist=
ered
Oct 25 14:59:04 comp_name kernel: ACPI: PCI interrupt for device 0000:00:02=
=2E0 disabled
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: Mo=
dules unloaded
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 45
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 50
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 5
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: ca=
lculated image_size: 500
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 4, text: 101
Oct 25 14:59:04 comp_name powersave-prepare_suspend_to_disk[8035]: DIAG: sc=
ript_return() invoked: event_id: 16, request: 0, text: prepare_sleep finish=
ed successfully for global.suspend2disk
Oct 25 14:59:04 comp_name powersave-do_screen_saver[8149]: DIAG: Process sc=
ript for event global.suspend2disk ID
Oct 25 14:59:04 comp_name powersave-do_screen_saver[8149]: INFO: Event: GLO=
BAL_SUSPEND2DISK occured.
Oct 25 14:59:04 comp_name powersave-do_screen_saver[8149]: INFO: Parameters=
: Event - global.suspend2disk; Current Active Scheme:  - ACPI event line:
Oct 25 14:59:04 comp_name kernel: swsusp: Marking nosave pages: 00000000000=
a0000 - 0000000000100000
Oct 25 14:59:04 comp_name kernel: swsusp: Basic memory bitmaps created
Oct 25 14:59:24 comp_name kernel: Stopping tasks ... fff c012478a c01167bb =
00003872 c033a02c
Oct 25 14:59:24 comp_name kernel:        dfe1b080 dcad5fb8 dcad5f90 dfe1b4d=
4 ffffffff 00000000 dcad5fb8 dcad4000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c01167bb>] update_curr+0x12b/0x140
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c027b64b>] __sched_text_start+0x13b/0x=
2d0
Oct 25 14:59:24 comp_name kernel:  [<c011c89d>] do_wait+0x3bd/0xa40
Oct 25 14:59:24 comp_name kernel:  [<c0116ae0>] default_wake_function+0x0/0=
x10
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: getty         D 02625a00     0  2099     =
 1
Oct 25 14:59:24 comp_name kernel:        dcab9ea4 00000086 dcab8000 02625a0=
0 00000000 00000000 00000000 bfe5bc10
Oct 25 14:59:24 comp_name kernel:        dcab9fb8 dcab9f10 c0139d28 0000000=
0 c012478a dcab9ed8 00000086 dcab8000
Oct 25 14:59:24 comp_name kernel:        c0302e40 dcab9fb8 dcab9f90 df2ddf1=
4 00000000 bfe5bc10 dcab9fb8 dcab8000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c01ffb03>] read_chan+0x273/0x5d0
Oct 25 14:59:24 comp_name kernel:  [<c01fc83f>] tty_read+0x8f/0xc0
Oct 25 14:59:24 comp_name kernel:  [<c01ff890>] read_chan+0x0/0x5d0
Oct 25 14:59:24 comp_name kernel:  [<c01fc7b0>] tty_read+0x0/0xc0
Oct 25 14:59:24 comp_name kernel:  [<c015c62d>] vfs_read+0x9d/0x140
Oct 25 14:59:24 comp_name kernel:  [<c015ca11>] sys_read+0x41/0x70
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: getty         D 02625a00     0  2100     =
 1
Oct 25 14:59:24 comp_name kernel:        db993ea4 00000082 db992000 02625a0=
0 00000000 00000000 00000000 bfe5bc10
Oct 25 14:59:24 comp_name kernel:        db993fb8 db993f10 c0139d28 0000000=
0 c012478a db993ed8 00000082 db992000
Oct 25 14:59:24 comp_name kernel:        dffac30c db993fb8 db993f90 dfe154d=
4 00000000 bfe5bc10 db993fb8 db992000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c01ffb03>] read_chan+0x273/0x5d0
Oct 25 14:59:24 comp_name kernel:  [<c01fc83f>] tty_read+0x8f/0xc0
Oct 25 14:59:24 comp_name kernel:  [<c01ff890>] read_chan+0x0/0x5d0
Oct 25 14:59:24 comp_name kernel:  [<c01fc7b0>] tty_read+0x0/0xc0
Oct 25 14:59:24 comp_name kernel:  [<c015c62d>] vfs_read+0x9d/0x140
Oct 25 14:59:24 comp_name kernel:  [<c015ca11>] sys_read+0x41/0x70
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: getty         D 02625a00     0  2101     =
 1
Oct 25 14:59:24 comp_name kernel:        dca9fea4 00000082 dca9e000 02625a0=
0 00000000 00000000 00000000 bf8eeea0
Oct 25 14:59:24 comp_name kernel:        dca9ffb8 dca9ff10 c0139d28 0000000=
0 c012478a dca9fed8 00000082 dca9e000
Oct 25 14:59:24 comp_name kernel:        dffac30c dca9ffb8 dca9ff90 dfe22f3=
4 00000000 bf8eeea0 dca9ffb8 dca9e000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c01ffb03>] read_chan+0x273/0x5d0
Oct 25 14:59:24 comp_name kernel:  [<c01fc83f>] tty_read+0x8f/0xc0
Oct 25 14:59:24 comp_name kernel:  [<c01ff890>] read_chan+0x0/0x5d0
Oct 25 14:59:24 comp_name kernel:  [<c01fc7b0>] tty_read+0x0/0xc0
Oct 25 14:59:24 comp_name kernel:  [<c015c62d>] vfs_read+0x9d/0x140
Oct 25 14:59:24 comp_name kernel:  [<c015ca11>] sys_read+0x41/0x70
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: getty         D 02625a00     0  2102     =
 1
Oct 25 14:59:24 comp_name kernel:        dcac1ea4 00000082 dcac0000 02625a0=
0 00000000 00000000 00000000 bfe67420
Oct 25 14:59:24 comp_name kernel:        dcac1fb8 dcac1f10 c0139d28 0000000=
0 c012478a dcac1ed8 00000082 dcac0000
Oct 25 14:59:24 comp_name kernel:        dffac30c dcac1fb8 dcac1f90 dfe1e4b=
4 00000000 bfe67420 dcac1fb8 dcac0000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c01ffb03>] read_chan+0x273/0x5d0
Oct 25 14:59:24 comp_name kernel:  [<c01fc83f>] tty_read+0x8f/0xc0
Oct 25 14:59:24 comp_name kernel:  [<c01ff890>] read_chan+0x0/0x5d0
Oct 25 14:59:24 comp_name kernel:  [<c01fc7b0>] tty_read+0x0/0xc0
Oct 25 14:59:24 comp_name kernel:  [<c015c62d>] vfs_read+0x9d/0x140
Oct 25 14:59:24 comp_name kernel:  [<c015ca11>] sys_read+0x41/0x70
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: encfs         D 00000000     0  2656     =
 1
Oct 25 14:59:24 comp_name kernel:        c8d03ea4 00000082 c8d02000 0000000=
0 00000000 00000000 00000000 b7a93008
Oct 25 14:59:24 comp_name kernel:        c8d03fb8 c8d03f10 c0139d28 0000000=
4 c012478a c0116ae0 00100100 00200200
Oct 25 14:59:24 comp_name kernel:        e0a48140 c8d03fb8 c8d03f90 caf879e=
4 00000004 b7a93008 c8d03fb8 c8d02000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0116ae0>] default_wake_function+0x0/0=
x10
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c012b1f0>] autoremove_wake_function+0x=
0/0x40
Oct 25 14:59:24 comp_name kernel:  [<e0a42e90>] fuse_dev_write+0x0/0x2f0 [f=
use]
Oct 25 14:59:24 comp_name kernel:  [<c015edde>] sys_lstat64+0x1e/0x30
Oct 25 14:59:24 comp_name kernel:  [<c015bcc0>] do_sync_read+0x0/0x120
Oct 25 14:59:24 comp_name kernel:  [<c015c62d>] vfs_read+0x9d/0x140
Oct 25 14:59:24 comp_name kernel:  [<c015ca11>] sys_read+0x41/0x70
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: mount.davfs   D d88b9000     0  2664     =
 1
Oct 25 14:59:24 comp_name kernel:        c88c5ea4 00200082 c88c4000 d88b900=
0 c11df7e0 00000000 00000000 00000000
Oct 25 14:59:24 comp_name kernel:        c88c5fb8 c88c5f10 c0139d28 0000000=
5 c012478a c01c476e 00004000 00000000
Oct 25 14:59:24 comp_name kernel:        0000000a c88c5fb8 c88c5f90 cd2ab9e=
4 00000005 00000000 c88c5fb8 c88c4000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c01c476e>] vsnprintf+0x2ae/0x600
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c014b66f>] unmap_vmas+0x27f/0x460
Oct 25 14:59:24 comp_name kernel:  [<c014cf05>] free_pgtables+0x85/0xc0
Oct 25 14:59:24 comp_name kernel:  [<c011430b>] check_pgt_cache+0x1b/0x20
Oct 25 14:59:24 comp_name kernel:  [<c014e139>] unmap_region+0xd9/0x100
Oct 25 14:59:24 comp_name kernel:  [<c01c5d50>] copy_to_user+0x30/0x60
Oct 25 14:59:24 comp_name kernel:  [<c0168508>] sys_select+0x1a8/0x1d0
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: do_screen_sav ? 00000001     0  3241   20=
16
Oct 25 14:59:24 comp_name kernel:        dd30df68 00000046 dd30c000 0000000=
1 c01bc9ee dff26e20 dd30df94 df611580
Oct 25 14:59:24 comp_name kernel:        00000010 df611664 c011d518 0000000=
1 00000002 00000000 dd30dfb8 dd30df94
Oct 25 14:59:24 comp_name kernel:        df61169c df611664 dffc2a90 dd30dfb=
8 dd30df94 dd30df94 00000000 b7f6a284
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c01bc9ee>] cfq_free_io_context+0x2e/0x=
60
Oct 25 14:59:24 comp_name kernel:  [<c011d518>] do_exit+0x508/0x780
Oct 25 14:59:24 comp_name kernel:  [<c011d7b3>] do_group_exit+0x23/0x60
Oct 25 14:59:24 comp_name kernel:  [<c010400e>] sysenter_past_esp+0x5f/0x85
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: do_screen_sav ? 00000001     0  5880   20=
16
Oct 25 14:59:24 comp_name kernel:        d2193f68 00000046 d2192000 0000000=
1 c01bc9ee dff26e40 d2193f94 c840bab0
Oct 25 14:59:24 comp_name kernel:        00000010 c840bb94 c011d518 0000000=
1 00000002 00000000 d2193fb8 d2193f94
Oct 25 14:59:24 comp_name kernel:        c840bbcc c840bb94 dffc2a90 d2193fb=
8 d2193f94 d2193f94 00000000 b7f45284
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c01bc9ee>] cfq_free_io_context+0x2e/0x=
60
Oct 25 14:59:24 comp_name kernel:  [<c011d518>] do_exit+0x508/0x780
Oct 25 14:59:24 comp_name kernel:  [<c011d7b3>] do_group_exit+0x23/0x60
Oct 25 14:59:24 comp_name kernel:  [<c010400e>] sysenter_past_esp+0x5f/0x85
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: do_screen_sav ? c14a8c80     0  6177   20=
16
Oct 25 14:59:24 comp_name kernel:        c17bff68 00000046 c17be000 c14a8c8=
0 c011c0c1 00000400 c17bff94 c724d560
Oct 25 14:59:24 comp_name kernel:        00000010 c724d644 c011d518 0000000=
1 00000002 00000000 c17bffb8 c17bff94
Oct 25 14:59:24 comp_name kernel:        c724d67c c724d644 dffc2a90 c17bffb=
8 c17bff94 c17bff94 00000000 b7ef9284
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c011c0c1>] put_files_struct+0x51/0xb0
Oct 25 14:59:24 comp_name kernel:  [<c011d518>] do_exit+0x508/0x780
Oct 25 14:59:24 comp_name kernel:  [<c011d7b3>] do_group_exit+0x23/0x60
Oct 25 14:59:24 comp_name kernel:  [<c010400e>] sysenter_past_esp+0x5f/0x85
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: dhclient3     D 00000000     0  6388     =
 1
Oct 25 14:59:24 comp_name kernel:        c0ac5ea4 00000082 c0ac4000 0000000=
0 19d09025 00000000 00000000 bfa774f4
Oct 25 14:59:24 comp_name kernel:        c0ac5fb8 c0ac5f10 c0139d28 0000000=
7 c012478a c0ac5ef8 bfa7767c cc1228b4
Oct 25 14:59:24 comp_name kernel:        df8c1a20 c0ac5fb8 c0ac5f90 c21c1f1=
4 00000007 bfa774f4 c0ac5fb8 c0ac4000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c014c0ac>] handle_mm_fault+0x2cc/0x560
Oct 25 14:59:24 comp_name kernel:  [<c0114af0>] do_page_fault+0x0/0x670
Oct 25 14:59:24 comp_name kernel:  [<c027cbe2>] error_code+0x6a/0x70
Oct 25 14:59:24 comp_name kernel:  [<c01c577f>] __copy_to_user_ll+0x2f/0x70
Oct 25 14:59:24 comp_name kernel:  [<c0168508>] sys_select+0x1a8/0x1d0
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: do_screen_sav ? dff3d240     0  6572   20=
16
Oct 25 14:59:24 comp_name kernel:        c0a1ff68 00000046 c0a1e000 dff3d24=
0 c011c0c1 00000400 c0a1ff94 c21c1030
Oct 25 14:59:24 comp_name kernel:        00000010 c21c1114 c011d518 0000000=
1 00000002 00000000 c0a1ffb8 c0a1ff94
Oct 25 14:59:24 comp_name kernel:        c21c114c c21c1114 dffc2a90 c0a1ffb=
8 c0a1ff94 c0a1ff94 00000000 b7f4e284
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c011c0c1>] put_files_struct+0x51/0xb0
Oct 25 14:59:24 comp_name kernel:  [<c011d518>] do_exit+0x508/0x780
Oct 25 14:59:24 comp_name kernel:  [<c011d7b3>] do_group_exit+0x23/0x60
Oct 25 14:59:24 comp_name kernel:  [<c010400e>] sysenter_past_esp+0x5f/0x85
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: do_screen_sav ? 00000001     0  7267   20=
16
Oct 25 14:59:24 comp_name kernel:        d0933f68 00000046 d0932000 0000000=
1 c01bc9ee dff26560 d0933f94 c6e8e560
Oct 25 14:59:24 comp_name kernel:        00000010 c6e8e644 c011d518 0000000=
1 00000002 00000000 d0933fb8 d0933f94
Oct 25 14:59:24 comp_name kernel:        c6e8e67c c6e8e644 dffc2a90 d0933fb=
8 d0933f94 d0933f94 00000000 b7eec284
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c01bc9ee>] cfq_free_io_context+0x2e/0x=
60
Oct 25 14:59:24 comp_name kernel:  [<c011d518>] do_exit+0x508/0x780
Oct 25 14:59:24 comp_name kernel:  [<c011d7b3>] do_group_exit+0x23/0x60
Oct 25 14:59:24 comp_name kernel:  [<c010400e>] sysenter_past_esp+0x5f/0x85
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: do_screen_sav ? dffc3140     0  7627   20=
16
Oct 25 14:59:24 comp_name kernel:        d6451f68 00000046 d6450000 dffc314=
0 c011c0c1 00000400 d6451f94 d9cb3a90
Oct 25 14:59:24 comp_name kernel:        00000010 d9cb3b74 c011d518 c013de2=
5 c02ece20 c02ead80 d6451fb8 d6451f94
Oct 25 14:59:24 comp_name kernel:        d9cb3bac d9cb3b74 dffc2a90 d6451fb=
8 d6451f94 d6451f94 00000000 b7f04284
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c011c0c1>] put_files_struct+0x51/0xb0
Oct 25 14:59:24 comp_name kernel:  [<c011d518>] do_exit+0x508/0x780
Oct 25 14:59:24 comp_name kernel:  [<c013de25>] handle_IRQ_event+0x25/0x50
Oct 25 14:59:24 comp_name kernel:  [<c011d7b3>] do_group_exit+0x23/0x60
Oct 25 14:59:24 comp_name kernel:  [<c010400e>] sysenter_past_esp+0x5f/0x85
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: sshd          D 000000cc     0  7840     =
 1
Oct 25 14:59:24 comp_name kernel:        dfcdfea4 00200086 dfcde000 000000c=
c c0140343 00000000 00000000 00000000
Oct 25 14:59:24 comp_name kernel:        dfcdffb8 dfcdff10 c0139d28 0000000=
4 c012478a dfcdfef8 da16f2cc d7597ac0
Oct 25 14:59:24 comp_name kernel:        dffac30c dfcdffb8 dfcdff90 da241a0=
4 00000004 00000000 dfcdffb8 dfcde000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0140343>] find_lock_page+0x23/0xa0
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c01423b0>] filemap_fault+0x0/0x390
Oct 25 14:59:24 comp_name kernel:  [<c014bebf>] handle_mm_fault+0xdf/0x560
Oct 25 14:59:24 comp_name kernel:  [<c01683ab>] sys_select+0x4b/0x1d0
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: login         D 00000010     0  7951     =
 1
Oct 25 14:59:24 comp_name kernel:        deda3ea4 00000086 deda2000 0000001=
0 c02f05a4 00000000 00000000 00000000
Oct 25 14:59:24 comp_name kernel:        deda3fb8 deda3f10 c0139d28 fffffff=
f c012478a c01167bb 00003a42 c033a02c
Oct 25 14:59:24 comp_name kernel:        dd3fbae0 deda3fb8 deda3f90 dd3fbf3=
4 ffffffff 00000000 deda3fb8 deda2000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c01167bb>] update_curr+0x12b/0x140
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c027b64b>] __sched_text_start+0x13b/0x=
2d0
Oct 25 14:59:24 comp_name kernel:  [<c011c89d>] do_wait+0x3bd/0xa40
Oct 25 14:59:24 comp_name kernel:  [<c0116ae0>] default_wake_function+0x0/0=
x10
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: bash          D fffffbff     0  7958   79=
51
Oct 25 14:59:24 comp_name kernel:        dcb83ea4 00000086 dcb82000 fffffbf=
f 00000001 00000000 00000000 082de108
Oct 25 14:59:24 comp_name kernel:        dcb83fb8 dcb83f10 c0139d28 fffffff=
f c012478a 00000001 0001a731 00000001
Oct 25 14:59:24 comp_name kernel:        c033a02c dcb83fb8 dcb83f90 df2dd9e=
4 ffffffff 082de108 dcb83fb8 dcb82000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c01162f1>] pick_next_task_fair+0x31/0x=
60
Oct 25 14:59:24 comp_name kernel:  [<c027b64b>] __sched_text_start+0x13b/0x=
2d0
Oct 25 14:59:24 comp_name kernel:  [<c011c89d>] do_wait+0x3bd/0xa40
Oct 25 14:59:24 comp_name kernel:  [<c0116ae0>] default_wake_function+0x0/0=
x10
Oct 25 14:59:24 comp_name kernel:  [<c011cf51>] sys_wait4+0x31/0x40
Oct 25 14:59:24 comp_name kernel:  [<c011cf87>] sys_waitpid+0x27/0x30
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: gdb           D 00000006     0  8003   79=
58
Oct 25 14:59:24 comp_name kernel:        db3ebea4 00000086 db3ea000 0000000=
6 bfcc3507 00000000 00000000 0823adf9
Oct 25 14:59:24 comp_name kernel:        db3ebfb8 db3ebf10 c0139d28 083166d=
0 c012478a db3ebef8 dbed4668 df0f0000
Oct 25 14:59:24 comp_name kernel:        dfdd7e30 db3ebfb8 db3ebf90 df6114d=
4 083166d0 0823adf9 db3ebfb8 db3ea000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c01fc084>] tty_write+0x1b4/0x1d0
Oct 25 14:59:24 comp_name kernel:  [<c015c551>] vfs_write+0x101/0x140
Oct 25 14:59:24 comp_name kernel:  [<c01c5d50>] copy_to_user+0x30/0x60
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: stringTest    t c0123f7b     0  8004   80=
03
Oct 25 14:59:24 comp_name kernel:        d972fea0 00000082 d972e000 c0123f7=
b 00000000 0000000a 00000006 00000006
Oct 25 14:59:24 comp_name kernel:        d972ffb8 d972ff10 c0123a0f 00001f4=
4 00000006 c012447d d972fef8 ffffffff
Oct 25 14:59:24 comp_name kernel:        dcb40000 dffac30c d972ffb8 d972ff9=
0 df611f34 00001f44 00000000 d972ffb8
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0123f7b>] dequeue_signal+0x6b/0x120
Oct 25 14:59:24 comp_name kernel:  [<c0123a0f>] ptrace_stop+0x8f/0xf0
Oct 25 14:59:24 comp_name kernel:  [<c012447d>] get_signal_to_deliver+0x9d/=
0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c0122efc>] __sigqueue_alloc+0x2c/0x70
Oct 25 14:59:24 comp_name kernel:  [<c01fc084>] tty_write+0x1b4/0x1d0
Oct 25 14:59:24 comp_name kernel:  [<c012288a>] recalc_sigpending+0xa/0x20
Oct 25 14:59:24 comp_name kernel:  [<c01228e5>] sigprocmask+0x45/0xb0
Oct 25 14:59:24 comp_name kernel:  [<c0124c31>] sys_rt_sigprocmask+0xb1/0xd0
Oct 25 14:59:24 comp_name kernel:  [<c0124c31>] sys_rt_sigprocmask+0xb1/0xd0
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: bash          D 0003b275     0  8007   20=
98
Oct 25 14:59:24 comp_name kernel:        dce9dea4 00000086 dce9c000 0003b27=
5 dce9dea4 00000000 00000000 bfbdfcbf
Oct 25 14:59:24 comp_name kernel:        dce9dfb8 dce9df10 c0139d28 0000000=
0 c012478a dce9ded8 00000086 dce9c000
Oct 25 14:59:24 comp_name kernel:        c0302e40 dce9dfb8 dce9df90 dffc64d=
4 00000000 bfbdfcbf dce9dfb8 dce9c000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c01ffb03>] read_chan+0x273/0x5d0
Oct 25 14:59:24 comp_name kernel:  [<c01fc83f>] tty_read+0x8f/0xc0
Oct 25 14:59:24 comp_name kernel:  [<c01ff890>] read_chan+0x0/0x5d0
Oct 25 14:59:24 comp_name kernel:  [<c01fc7b0>] tty_read+0x0/0xc0
Oct 25 14:59:24 comp_name kernel:  [<c015c62d>] vfs_read+0x9d/0x140
Oct 25 14:59:24 comp_name kernel:  [<c015ca11>] sys_read+0x41/0x70
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: prepare_suspe D ffff52a3     0  8035   20=
16
Oct 25 14:59:24 comp_name kernel:        ddb7fea4 00000086 ddb7e000 ffff52a=
3 0000ef98 00000000 00000000 08137228
Oct 25 14:59:24 comp_name kernel:        ddb7ffb8 ddb7ff10 c0139d28 fffffff=
f c012478a 000002c4 00c5a867 00000001
Oct 25 14:59:24 comp_name kernel:        c033a02c ddb7ffb8 ddb7ff90 dfaa34d=
4 ffffffff 08137228 ddb7ffb8 ddb7e000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c027b64b>] __sched_text_start+0x13b/0x=
2d0
Oct 25 14:59:24 comp_name kernel:  [<c011c89d>] do_wait+0x3bd/0xa40
Oct 25 14:59:24 comp_name kernel:  [<c0116ae0>] default_wake_function+0x0/0=
x10
Oct 25 14:59:24 comp_name kernel:  [<c011cf51>] sys_wait4+0x31/0x40
Oct 25 14:59:24 comp_name kernel:  [<c011cf87>] sys_waitpid+0x27/0x30
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: dbus-send     D 00000120     0  8148   80=
35
Oct 25 14:59:24 comp_name kernel:        dfc8dea4 00000086 dfc8c000 0000012=
0 00000000 00000000 00000000 0804c2e0
Oct 25 14:59:24 comp_name kernel:        dfc8dfb8 dfc8df10 c0139d28 bfa1fac=
0 c012478a 00000000 00000000 df8eeec0
Oct 25 14:59:24 comp_name kernel:        dfaa3ab0 dfc8dfb8 dfc8df90 dfaa3f3=
4 bfa1fac0 0804c2e0 dfc8dfb8 dfc8c000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c015b9dd>] rw_copy_check_uvector+0x7d/=
0x100
Oct 25 14:59:24 comp_name kernel:  [<c015c348>] do_readv_writev+0x118/0x180
Oct 25 14:59:24 comp_name kernel:  [<c022d540>] sock_aio_write+0x0/0x100
Oct 25 14:59:24 comp_name kernel:  [<c011628c>] update_stats_wait_end+0x9c/=
0xd0
Oct 25 14:59:24 comp_name kernel:  [<c01162f1>] pick_next_task_fair+0x31/0x=
60
Oct 25 14:59:24 comp_name kernel:  [<c012eebf>] do_gettimeofday+0x2f/0xd0
Oct 25 14:59:24 comp_name kernel:  [<c01c5d50>] copy_to_user+0x30/0x60
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: do_screen_sav D d57199a0     0  8149   20=
16
Oct 25 14:59:24 comp_name kernel:        db937ea4 00000082 db936000 d57199a=
0 c0142372 00000000 00000000 080e3198
Oct 25 14:59:24 comp_name kernel:        db937fb8 db937f10 c0139d28 0000000=
0 c012478a 08113542 00000000 0000153a
Oct 25 14:59:24 comp_name kernel:        c02868e0 db937fb8 db937f90 c14af9e=
4 00000000 080e3198 db937fb8 db936000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0142372>] generic_file_aio_read+0x132=
/0x170
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c012b1f0>] autoremove_wake_function+0x=
0/0x40
Oct 25 14:59:24 comp_name kernel:  [<c015f14e>] sys_fstat64+0x1e/0x30
Oct 25 14:59:24 comp_name kernel:  [<c015c68f>] vfs_read+0xff/0x140
Oct 25 14:59:24 comp_name kernel:  [<c015ca11>] sys_read+0x41/0x70
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: do_acpi_sleep D fffffbff     0  8150   20=
16
Oct 25 14:59:24 comp_name kernel:        dd3f3ea4 00000082 dd3f2000 fffffbf=
f 0000c0c2 00000000 00000000 08105c08
Oct 25 14:59:24 comp_name kernel:        dd3f3fb8 dd3f3f10 c0139d28 fffffff=
f c012478a 00006061 0133dd86 00000001
Oct 25 14:59:24 comp_name kernel:        c033a02c dd3f3fb8 dd3f3f90 dfe22a0=
4 ffffffff 08105c08 dd3f3fb8 dd3f2000
Oct 25 14:59:24 comp_name kernel: Call Trace:
Oct 25 14:59:24 comp_name kernel:  [<c0139d28>] refrigerator+0x48/0x70
Oct 25 14:59:24 comp_name kernel:  [<c012478a>] get_signal_to_deliver+0x3aa=
/0x3d0
Oct 25 14:59:24 comp_name kernel:  [<c0103741>] do_notify_resume+0x91/0x6e0
Oct 25 14:59:24 comp_name kernel:  [<c01162f1>] pick_next_task_fair+0x31/0x=
60
Oct 25 14:59:24 comp_name kernel:  [<c027b64b>] __sched_text_start+0x13b/0x=
2d0
Oct 25 14:59:24 comp_name kernel:  [<c011c89d>] do_wait+0x3bd/0xa40
Oct 25 14:59:24 comp_name kernel:  [<c0116ae0>] default_wake_function+0x0/0=
x10
Oct 25 14:59:24 comp_name kernel:  [<c011cf51>] sys_wait4+0x31/0x40
Oct 25 14:59:24 comp_name kernel:  [<c011cf87>] sys_waitpid+0x27/0x30
Oct 25 14:59:24 comp_name kernel:  [<c0104112>] work_notifysig+0x13/0x19
Oct 25 14:59:24 comp_name kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 25 14:59:24 comp_name kernel: myecho        R running      0  8158   81=
50
Oct 25 14:59:24 comp_name kernel:  stringTest
Oct 25 14:59:24 comp_name powersave-do_screen_saver[8149]: INFO: process sc=
ript: screen_saver
Oct 25 14:59:24 comp_name kernel: Restarting tasks ... done.
Oct 25 14:59:24 comp_name kernel: swsusp: Basic memory bitmaps freed
Oct 25 14:59:24 comp_name powersave-restore_after_suspend_to_disk[8162]: DI=
AG: Process script for event global.resume.suspend2disk ID 17
Oct 25 14:59:24 comp_name powersave-restore_after_suspend_to_disk[8162]: IN=
=46O: Event: GLOBAL_RESUME_SUSPEND2DISK occured.
Oct 25 14:59:24 comp_name powersave-restore_after_suspend_to_disk[8162]: IN=
=46O: Parameters: Event - global.resume.suspend2disk; Current Active Scheme=
: scheme_performance - ACPI event line: empty
Oct 25 14:59:24 comp_name kernel: ohci_hcd: 2006 August 04 USB 1.1 'Open' H=
ost Controller (OHCI) Driver
Oct 25 14:59:24 comp_name kernel: ACPI: PCI Interrupt 0000:00:02.0[A] -> Li=
nk [APCF] -> GSI 21 (level, high) -> IRQ 18
Oct 25 14:59:24 comp_name kernel: PCI: Setting latency timer of device 0000=
:00:02.0 to 64
Oct 25 14:59:24 comp_name kernel: ohci_hcd 0000:00:02.0: OHCI Host Controll=
er
Oct 25 14:59:24 comp_name kernel: ohci_hcd 0000:00:02.0: new USB bus regist=
ered, assigned bus number 1
Oct 25 14:59:24 comp_name kernel: ohci_hcd 0000:00:02.0: irq 18, io mem 0xe=
f003000
Oct 25 14:59:24 comp_name powersave-do_screen_saver[8149]: DIAG: script_ret=
urn() invoked: event_id: 0, request: Script screen_saver, text:
Oct 25 14:59:24 comp_name kernel: usb usb1: configuration #1 chosen from 1 =
choice
Oct 25 14:59:24 comp_name kernel: hub 1-0:1.0: USB hub found
Oct 25 14:59:24 comp_name kernel: hub 1-0:1.0: 3 ports detected
Oct 25 14:59:25 comp_name kernel: ACPI: PCI Interrupt 0000:00:02.1[B] -> Li=
nk [APCG] -> GSI 21 (level, high) -> IRQ 18
Oct 25 14:59:25 comp_name kernel: PCI: Setting latency timer of device 0000=
:00:02.1 to 64
Oct 25 14:59:25 comp_name kernel: ohci_hcd 0000:00:02.1: OHCI Host Controll=
er
Oct 25 14:59:25 comp_name kernel: ohci_hcd 0000:00:02.1: new USB bus regist=
ered, assigned bus number 3
Oct 25 14:59:25 comp_name kernel: ohci_hcd 0000:00:02.1: irq 18, io mem 0xe=
f004000
Oct 25 14:59:25 comp_name kernel: usb usb3: configuration #1 chosen from 1 =
choice
Oct 25 14:59:25 comp_name kernel: hub 3-0:1.0: USB hub found
Oct 25 14:59:25 comp_name kernel: hub 3-0:1.0: 3 ports detected
Oct 25 14:59:25 comp_name kernel: Initializing USB Mass Storage driver...
Oct 25 14:59:25 comp_name kernel: usb 1-2: new full speed USB device using =
ohci_hcd and address 2
Oct 25 14:59:25 comp_name kernel: usb 1-2: configuration #1 chosen from 1 c=
hoice
Oct 25 14:59:26 comp_name kernel: eth0: Hardware identity 0001:0003:0004:00=
02
Oct 25 14:59:26 comp_name kernel: eth0: Station identity  001f:0001:0006:00=
10
Oct 25 14:59:26 comp_name kernel: eth0: Firmware determined as Lucent/Agere=
 6.16
Oct 25 14:59:26 comp_name kernel: eth0: Ad-hoc demo mode supported
Oct 25 14:59:26 comp_name kernel: eth0: IEEE standard IBSS ad-hoc mode supp=
orted
Oct 25 14:59:26 comp_name kernel: eth0: MAC address 00:02:2D:31:B9:72
Oct 25 14:59:26 comp_name kernel: eth0: Station name "HERMES I"
Oct 25 14:59:26 comp_name kernel: eth0: ready
Oct 25 14:59:26 comp_name kernel: usb 3-2: new low speed USB device using o=
hci_hcd and address 2
Oct 25 14:59:26 comp_name kernel: usb 3-2: configuration #1 chosen from 1 c=
hoice
Oct 25 14:59:26 comp_name kernel: input: Microsoft Microsoft Wheel Mouse Op=
tical=AE as /devices/pci0000:00/0000:00:02.1/usb3/3-2/3-2:1.0/input/input11
Oct 25 14:59:26 comp_name kernel: input: USB HID v1.00 Mouse [Microsoft Mic=
rosoft Wheel Mouse Optical=AE] on usb-0000:00:02.1-2
Oct 25 14:59:26 comp_name kernel: usbcore: registered new interface driver =
usb-storage
Oct 25 14:59:26 comp_name kernel: USB Mass Storage support registered.
Oct 25 14:59:26 comp_name powersave-restore_after_suspend_to_disk[8162]: DI=
AG: Modules loaded
Oct 25 14:59:26 comp_name powersave-restore_after_suspend_to_disk[8162]: DI=
AG: Service hdparm started again
Oct 25 14:59:26 comp_name dhclient: Internet Systems Consortium DHCP Client=
 V3.0.6
Oct 25 14:59:26 comp_name dhclient: Copyright 2004-2007 Internet Systems Co=
nsortium.
Oct 25 14:59:26 comp_name dhclient: All rights reserved.
Oct 25 14:59:26 comp_name dhclient: For info, please visit http://www.isc.o=
rg/sw/dhcp/
Oct 25 14:59:26 comp_name dhclient:
Oct 25 14:59:26 comp_name kernel: eth0: New link status: Connected (0001)
Oct 25 14:59:27 comp_name dhclient: Listening on LPF/eth0/00:02:2d:31:b9:72
Oct 25 14:59:27 comp_name dhclient: Sending on   LPF/eth0/00:02:2d:31:b9:72
Oct 25 14:59:27 comp_name dhclient: Sending on   Socket/fallback
Oct 25 14:59:27 comp_name dhclient: DHCPDISCOVER on eth0 to 255.255.255.255=
 port 67 interval 4
Oct 25 14:59:29 comp_name dhclient: DHCPOFFER from 192.168.1.100
Oct 25 14:59:29 comp_name dhclient: DHCPREQUEST on eth0 to 255.255.255.255 =
port 67
Oct 25 14:59:31 comp_name dhclient: DHCPACK from 192.168.1.100
Oct 25 14:59:31 comp_name dhclient: bound to 192.168.1.2 -- renewal in 3507=
9 seconds.
Oct 25 14:59:35 comp_name ntpdate[8299]: adjust time server 128.10.252.6 of=
fset 0.426569 sec
Oct 25 14:59:35 comp_name powersave-restore_after_suspend_to_disk[8162]: DI=
AG: Service networking started again
Oct 25 14:59:35 comp_name powersave-restore_after_suspend_to_disk[8162]: DI=
AG: script_return() invoked: event_id: 17, request: 0, text: restore_after_=
suspend2disk finished

--Boundary-00=_fzTIHZVS1Wg5bPm--

Return-Path: <linux-kernel-owner+w=401wt.eu-S964780AbXAWM0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780AbXAWM0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 07:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964806AbXAWM0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 07:26:00 -0500
Received: from cweiske.de ([80.237.146.62]:59737 "EHLO mail.cweiske.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964801AbXAWMZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 07:25:58 -0500
X-Greylist: delayed 1301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jan 2007 07:25:58 EST
Message-ID: <45B5F9B0.3050006@cweiske.de>
Date: Tue, 23 Jan 2007 13:04:00 +0100
From: Christian Weiske <cweiske@cweiske.de>
User-Agent: My own hands[TM]
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel panic when inserting usb isdn modem
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=24EAF823
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2E5EB17A138DBAF27D3A8DFB"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2E5EB17A138DBAF27D3A8DFB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,


I reproducably get a kernel panic when plugging in a usb isdn modem,
Billion tiny USB ISDN TA 128).
It is said to work with the hfc_usb isdn drivers in the kernel, so I
compiled them into it.

Kernel is 2.6.20-rc5, gcc 3.4.6 on a via epia 5000 board.

Is there anything I can do? Shall I file a bug report?

When plugging the usb cable, I get this:
Oops: 0000 [#1]
PREEMPT
Modules linked in:
CPU:    0
EIP:    0060:[<00000000>]    Not tainted VLI
EFLAGS: 00010046   (2.6.20-rc5 #2)
EIP is at 0x0
eax: d5ab6000   ebx: d5ab6a03   ecx: 00000000   edx: 00000112
esi: d5ab6000   edi: 00000005   ebp: c064beec   esp: c064bedc
ds: 007b   es: 007b   ss: 0068
Process khubd (pid: 131, ti=3Dc064b000 task=3Dd7dae050 task.ti=3Dd7d97000=
)
Stack: c03a6808 00ab6ac0 d5ab6ac0 d4e2db08 c064bf10 c03a74cc c04b5a49
d7ac1628
       00000040 00000002 d4e2db08 d7a9b308 00000000 c064bf28 c034a82f
00000000
       d7a9b41c d7aca5a0 d679a3e8 c064bf5c c035e462 c035e600 00000001
c064bf50
Call Trace:
 [<c010352a>] show_trace_log_lvl+0x1a/0x30
 [<c01035fa>] show_stack_log_lvl+0x9a/0xd0
 [<c0103846>] show_registers+0x1c6/0x340
 [<c0103bc1>] die+0x171/0x230
 [<c010f906>] do_page_fault+0x366/0x5b0
 [<c04b5f74>] error_code+0x74/0x80
 [<c03a74cc>] rx_complete+0x8c/0x150
 [<c034a82f>] usb_hcd_giveback_urb+0x3f/0xb0
 [<c035e462>] uhci_giveback_urb+0x82/0x1c0
 [<c035e63c>] uhci_scan_qh+0x9c/0x240
 [<c035e958>] uhci_scan_schedule+0x98/0x130
 [<c035f757>] uhci_irq+0xd7/0x180
 [<c034a8c5>] usb_hcd_irq+0x25/0x60
 [<c0146330>] handle_IRQ_event+0x30/0x70
 [<c01473dd>] handle_level_irq+0x7d/0x110
 [<c0104fe7>] do_IRQ+0x87/0xd0
 [<c010324e>] common_interrupt+0x2e/0x40
 [<c0165420>] cache_alloc_debugcheck_after+0xc0/0x180
 [<c0165afa>] __kmalloc_track_caller+0xaa/0x100
 [<c03f133d>] __alloc_skb+0x4d/0x110
 [<c028fff1>] kobject_uevent_env+0x2e1/0x4e0
 [<c02901fa>] kobject_uevent+0xa/0x10
 [<c03020cf>] device_del+0x8f/0x220
 [<c030226b>] device_unregister+0xb/0x20
 [<c0350a18>] usb_remove_ep_files+0x58/0x70
 [<c035020a>] usb_create_sysfs_intf_files+0xca/0x100
 [<c034ce43>] usb_set_configuration+0x313/0x470
 [<c0353f16>] generic_probe+0x26/0x80
 [<c034d32c>] usb_probe_device+0x4c/0x60
 [<c03041f4>] really_probe+0x94/0x110
 [<c0304329>] driver_probe_device+0x99/0xd0
 [<c0304368>] __device_attach+0x8/0x10
 [<c0303619>] bus_for_each_drv+0x49/0x70
 [<c03043d6>] device_attach+0x66/0x90
 [<c0303861>] bus_attach_device+0x21/0x50
 [<c0301d49>] device_add+0x199/0x430
 [<c0347233>] __usb_new_device+0x63/0xf0
 [<c0347327>] usb_new_device+0x67/0xa0
 [<c03482b3>] hub_port_connect_change+0x1c3/0x3d0
 [<c034868d>] hub_events+0x1cd/0x3e0
 [<c03488b5>] hub_thread+0x15/0x100
 [<c012c494>] kthread+0x94/0xc0
 [<c0103387>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:c064bedc
 <0>Kernel panic - not syncing: Fatal exception in interrupt


# ./scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux dojo 2.6.20-rc5 #2 PREEMPT Tue Jan 23 11:39:40 CET 2007 i686 VIA
Samuel 2 CentaurHauls GNU/Linux

Gnu C                  3.4.6
Gnu make               3.81
binutils               2.16.1
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.39
reiserfsprogs          3.6.19
Linux C Library        > libc.2.4
Dynamic linker (ldd)   2.4
Procps                 3.2.6
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.4
udev                   103
Modules Loaded



Please CC me, I am not subscribed.
--=20
Regards/Mit freundlichen Gr=C3=BC=C3=9Fen
Christian Weiske


--------------enig2E5EB17A138DBAF27D3A8DFB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFtfmyFMhaCCTq+CMRAlamAJ9pFCbonxBJC84A8juurPbPV6sgFQCgpoI/
+57GRPq3VW3LlZaAu2FhtP0=
=ijzw
-----END PGP SIGNATURE-----

--------------enig2E5EB17A138DBAF27D3A8DFB--

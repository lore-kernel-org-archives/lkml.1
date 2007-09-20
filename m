Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbXITTTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbXITTTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbXITTTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:19:23 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59875 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752898AbXITTTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:19:21 -0400
X-Sasl-enc: QwFCfHkzNRxmN+fubzM43sQcpkUwiy0H+a6uBtZxYHki 1190315960
Message-ID: <46F2C7F8.3040409@imap.cc>
Date: Thu, 20 Sep 2007 21:20:24 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.23-rc6-mm1
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F1AA6E.1030708@imap.cc>
In-Reply-To: <46F1AA6E.1030708@imap.cc>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig13A83C722E5387F0D72CBB53"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig13A83C722E5387F0D72CBB53
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Another data point. When booting into runlevel 3, the system is usable,
although these messages still appear after boot:

<4>[   22.731025] sysfs: duplicate filename 'bInterfaceNumber' can not be=
 created
<4>[   22.735872] WARNING: at fs/sysfs/dir.c:433 sysfs_add_one()
<7>[   22.740737] bas_gigaset: <-------3: 0x11 (0 [0x00 0x00])
<4>[   22.740881]  [dump_trace+100/498] dump_trace+0x64/0x1f2
<7>[   22.745708] bas_gigaset: <-------3: 0x11 (0 [0x00 0x00])
<4>[   22.745721]  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2=
f
<4>[   22.750533]  [show_trace+18/20] show_trace+0x12/0x14
<4>[   22.755285]  [dump_stack+22/24] dump_stack+0x16/0x18
<4>[   22.759997]  [sysfs_add_one+87/188] sysfs_add_one+0x57/0xbc
<4>[   22.764633]  [sysfs_add_file+73/135] sysfs_add_file+0x49/0x87
<4>[   22.769418]  [sysfs_create_group+138/240] sysfs_create_group+0x8a/0=
xf0
<4>[   22.774014]  [<fa99c20a>] usb_create_sysfs_intf_files+0x2d/0xa2 [us=
bcore]
<4>[   22.778659]  [<fa9989ed>] usb_set_configuration+0x450/0x48d [usbcor=
e]
<4>[   22.783246]  [<fa99fa9b>] generic_probe+0x53/0x94 [usbcore]
<4>[   22.787895]  [<fa99a00b>] usb_probe_device+0x35/0x3b [usbcore]
<4>[   22.792471]  [driver_probe_device+233/362] driver_probe_device+0xe9=
/0x16a
<4>[   22.797214]  [__device_attach+8/10] __device_attach+0x8/0xa
<4>[   22.801779]  [bus_for_each_drv+56/97] bus_for_each_drv+0x38/0x61
<4>[   22.806344]  [device_attach+112/133] device_attach+0x70/0x85
<4>[   22.810905]  [bus_attach_device+41/119] bus_attach_device+0x29/0x77=

<4>[   22.815468]  [device_add+795/1342] device_add+0x31b/0x53e
<4>[   22.820052]  [<fa993de7>] usb_new_device+0x5c/0x168 [usbcore]
<4>[   22.824653]  [<fa9954f9>] hub_thread+0x6b9/0xaa5 [usbcore]
<4>[   22.829276]  [kthread+59/100] kthread+0x3b/0x64
<4>[   22.833823]  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0=
x10
<4>[   22.838409]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

and a bit later:

Sep 20 20:54:36 xenon kernel: [   39.581898] hwinfo[5185]: segfault at b7=
cf9f10 eip b7cf9f10 esp bfefe20c error 4
Sep 20 20:54:36 xenon kernel: [   39.586320] BUG: sleeping function calle=
d from invalid context at kernel/rwsem.c:47
Sep 20 20:54:36 xenon kernel: [   39.590697] in_atomic():1, irqs_disabled=
():0
Sep 20 20:54:36 xenon kernel: [   39.594987] no locks held by hwinfo/5185=
=2E
Sep 20 20:54:36 xenon kernel: [   39.599281]  [<c0108441>] dump_trace+0x6=
4/0x1f2
Sep 20 20:54:36 xenon kernel: [   39.603577]  [<c01085e9>] show_trace_log=
_lvl+0x1a/0x2f
Sep 20 20:54:36 xenon kernel: [   39.607851]  [<c010902b>] show_trace+0x1=
2/0x14
Sep 20 20:54:36 xenon kernel: [   39.612060]  [<c0109154>] dump_stack+0x1=
6/0x18
Sep 20 20:54:36 xenon kernel: [   39.616305]  [<c0123ecd>] __might_sleep+=
0xe5/0xeb
Sep 20 20:54:36 xenon kernel: [   39.620545]  [<c013f72d>] down_write+0x1=
8/0x54
Sep 20 20:54:36 xenon kernel: [   39.624777]  [<c01890d7>] do_coredump+0x=
94/0x77d
Sep 20 20:54:36 xenon kernel: [   39.629004]  [<c0135295>] get_signal_to_=
deliver+0x408/0x434
Sep 20 20:54:36 xenon kernel: [   39.633252]  [<c010673a>] do_notify_resu=
me+0x94/0x6a6
Sep 20 20:54:36 xenon kernel: [   39.637554]  [<c01072e5>] work_notifysig=
+0x13/0x1a
Sep 20 20:54:36 xenon kernel: [   39.641854]  [<b7cf9f10>] 0xb7cf9f10
Sep 20 20:54:36 xenon kernel: [   39.646180]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Sep 20 20:54:36 xenon kernel: [   39.650407] note: hwinfo[5185] exited wi=
th preempt_count 1
Sep 20 20:54:36 xenon kernel: [   39.654553] BUG: scheduling while atomic=
: hwinfo/5185/0x10000002
Sep 20 20:54:36 xenon kernel: [   39.658714] no locks held by hwinfo/5185=
=2E
Sep 20 20:54:36 xenon kernel: [   39.662847]  [<c0108441>] dump_trace+0x6=
4/0x1f2
Sep 20 20:54:36 xenon kernel: [   39.666980]  [<c01085e9>] show_trace_log=
_lvl+0x1a/0x2f
Sep 20 20:54:36 xenon kernel: [   39.671118]  [<c010902b>] show_trace+0x1=
2/0x14
Sep 20 20:54:36 xenon kernel: [   39.675397]  [<c0109154>] dump_stack+0x1=
6/0x18
Sep 20 20:54:36 xenon kernel: [   39.679509]  [<c012605c>] __schedule_bug=
+0x6e/0x75
Sep 20 20:54:36 xenon kernel: [   39.683659]  [<c030fd4b>] __sched_text_s=
tart+0x83/0x59e
Sep 20 20:54:36 xenon kernel: [   39.687720]  [<c0126084>] __cond_resched=
+0x21/0x3b
Sep 20 20:54:36 xenon kernel: [   39.691751]  [<c031072b>] cond_resched+0=
x26/0x31
Sep 20 20:54:36 xenon kernel: [   39.695678]  [<c017059a>] unmap_vmas+0x4=
61/0x580
Sep 20 20:54:36 xenon kernel: [   39.699572]  [<c017351b>] exit_mmap+0x7f=
/0x10f
Sep 20 20:54:36 xenon kernel: [   39.703471]  [<c012807b>] mmput+0x4d/0xc=
b
Sep 20 20:54:36 xenon kernel: [   39.707318]  [<c012bea5>] exit_mm+0xd7/0=
xdc
Sep 20 20:54:36 xenon kernel: [   39.711140]  [<c012d3bb>] do_exit+0x224/=
0x76b
Sep 20 20:54:36 xenon kernel: [   39.711147]  [<c012d972>] sys_exit_group=
+0x0/0x11
Sep 20 20:54:36 xenon kernel: [   39.711153]  [<c013529c>] get_signal_to_=
deliver+0x40f/0x434
Sep 20 20:54:36 xenon kernel: [   39.711158]  [<c010673a>] do_notify_resu=
me+0x94/0x6a6
Sep 20 20:54:36 xenon kernel: [   39.711163]  [<c01072e5>] work_notifysig=
+0x13/0x1a
Sep 20 20:54:36 xenon kernel: [   39.711169]  [<b7cf9f10>] 0xb7cf9f10
Sep 20 20:54:36 xenon kernel: [   39.711175]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

As this seems to concern USB and sysfs, I guess Greg's the man?

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig13A83C722E5387F0D72CBB53
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG8sf4MdB4Whm86/kRAo7GAJ9Cl0tq8/CbKu2G/rjCZCtyl5dyMgCdGtfb
zsyYUCXBzYuJkZf6fhJmIOM=
=Nk4Y
-----END PGP SIGNATURE-----

--------------enig13A83C722E5387F0D72CBB53--

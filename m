Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbZLJUjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbZLJUjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 15:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757616AbZLJUjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 15:39:07 -0500
Received: from mail.klingt.org ([86.59.21.178]:54131 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757365AbZLJUjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 15:39:06 -0500
Message-ID: <4B215C64.8050206@klingt.org>
Date: Thu, 10 Dec 2009 21:39:00 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7pre) Gecko/20091209 Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dieb13 <dieb13@klingt.org>
Subject: WARNING: at fs/notify/inotify/inotify_fsnotify.c:129
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2EC76720E6AFA038BC6AE198"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Thu, 10 Dec 2009 21:39:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2EC76720E6AFA038BC6AE198
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

running 2.6.31.6 or 2.6.32 on a server machine, i see the following=20
warning in my logs:

Dec  9 00:37:37 es kernel: ------------[ cut here ]------------
Dec  9 00:37:37 es kernel: WARNING: at fs/notify/inotify/inotify_fsnotify=
=2Ec:129 idr_callback+0x2a/0x4b()
Dec  9 00:37:37 es kernel: Hardware name:
Dec  9 00:37:37 es kernel: inotify closing but id=3D0 for entry=3Df4582be=
0 in group=3De9811f40 still in idr.  Probably leaking memory
Dec  9 00:37:37 es kernel: Modules linked in: xt_multiport ipt_REJECT xt_=
tcpudp iptable_filter ip_tables x_tables dm_mod coretemp fan i2c_i801 i2c=
_core uhci_hcd e1000e psmouse intel_agp pcspkr serio_raw ehci_hcd button =
rtc_cmos evdev processor thermal ata_generic
Dec  9 00:37:37 es kernel: Pid: 10623, comm: imap Tainted: G        W  2.=
6.31.6 #2
Dec  9 00:37:37 es kernel: Call Trace:
Dec  9 00:37:37 es kernel:  [<c0229095>] ? warn_slowpath_common+0x5e/0x8a=

Dec  9 00:37:37 es kernel:  [<c02290f3>] ? warn_slowpath_fmt+0x26/0x2a
Dec  9 00:37:37 es kernel:  [<c02be26c>] ? idr_callback+0x2a/0x4b
Dec  9 00:37:37 es kernel:  [<c032b219>] ? idr_for_each+0x5a/0x91
Dec  9 00:37:37 es kernel:  [<c02be242>] ? idr_callback+0x0/0x4b
Dec  9 00:37:37 es kernel:  [<c02bc7cb>] ? fsnotify_remove_notify_event+0=
x27/0x60
Dec  9 00:37:37 es kernel:  [<c02be233>] ? inotify_free_group_priv+0x12/0=
x21
Dec  9 00:37:37 es kernel:  [<c02bcae1>] ? fsnotify_final_destroy_group+0=
x16/0x1e
Dec  9 00:37:37 es kernel:  [<c02be3a8>] ? inotify_release+0x16/0x22
Dec  9 00:37:37 es kernel:  [<c029b567>] ? __fput+0xc0/0x16a
Dec  9 00:37:37 es kernel:  [<c0298c50>] ? filp_close+0x4e/0x54
Dec  9 00:37:37 es kernel:  [<c0298cb0>] ? sys_close+0x5a/0x8d
Dec  9 00:37:37 es kernel:  [<c0202844>] ? sysenter_do_call+0x12/0x22
Dec  9 00:37:37 es kernel: ---[ end trace 4eaa2a86a8e2da27 ]---
Dec  9 00:37:37 es kernel: entry->group=3D(null) inode=3D(null) wd=3D1024=

Dec  9 00:37:37 es kernel: ------------[ cut here ]------------
Dec  9 00:37:37 es kernel: WARNING: at fs/notify/inotify/inotify_fsnotify=
=2Ec:129 idr_callback+0x2a/0x4b()
Dec  9 00:37:37 es kernel: Hardware name:
Dec  9 00:37:37 es kernel: inotify closing but id=3D0 for entry=3Df54ef3a=
c in group=3Df59681c0 still in idr.  Probably leaking memory
Dec  9 00:37:37 es kernel: Modules linked in: xt_multiport ipt_REJECT xt_=
tcpudp iptable_filter ip_tables x_tables dm_mod coretemp fan i2c_i801 i2c=
_core uhci_hcd e1000e psmouse intel_agp pcspkr serio_raw ehci_hcd button =
rtc_cmos evdev processor thermal ata_generic
Dec  9 00:37:37 es kernel: Pid: 11453, comm: imap Tainted: G        W  2.=
6.31.6 #2
Dec  9 00:37:37 es kernel: Call Trace:
Dec  9 00:37:37 es kernel:  [<c0229095>] ? warn_slowpath_common+0x5e/0x8a=

Dec  9 00:37:37 es kernel:  [<c02290f3>] ? warn_slowpath_fmt+0x26/0x2a
Dec  9 00:37:37 es kernel:  [<c02be26c>] ? idr_callback+0x2a/0x4b
Dec  9 00:37:37 es kernel:  [<c032b219>] ? idr_for_each+0x5a/0x91
Dec  9 00:37:37 es kernel:  [<c02be242>] ? idr_callback+0x0/0x4b
Dec  9 00:37:37 es kernel:  [<c02be233>] ? inotify_free_group_priv+0x12/0=
x21
Dec  9 00:37:37 es kernel:  [<c02bcae1>] ? fsnotify_final_destroy_group+0=
x16/0x1e
Dec  9 00:37:37 es kernel:  [<c02be3a8>] ? inotify_release+0x16/0x22
Dec  9 00:37:37 es kernel:  [<c029b567>] ? __fput+0xc0/0x16a
Dec  9 00:37:37 es kernel:  [<c0298c50>] ? filp_close+0x4e/0x54
Dec  9 00:37:37 es kernel:  [<c0298cb0>] ? sys_close+0x5a/0x8d
Dec  9 00:37:37 es kernel:  [<c0202844>] ? sysenter_do_call+0x12/0x22
Dec  9 00:37:37 es kernel: ---[ end trace 4eaa2a86a8e2da28 ]---
Dec  9 00:37:37 es kernel: entry->group=3D(null) inode=3D(null) wd=3D1024=



Dec 10 00:32:10 es kernel: ------------[ cut here ]------------
Dec 10 00:32:10 es kernel: WARNING: at fs/notify/inotify/inotify_fsnotify=
=2Ec:129 idr_callback+0x2a/0x4b()
Dec 10 00:32:10 es kernel: Hardware name:
Dec 10 00:32:10 es kernel: inotify closing but id=3D0 for entry=3Dee6d47e=
4 in group=3Df585fe40 still in idr.  Probably leaking memory
Dec 10 00:32:10 es kernel: Modules linked in: xt_multiport ipt_REJECT xt_=
tcpudp iptable_filter ip_tables x_tables dm_mod coretemp fan uhci_hcd i2c=
_i801 pcspkr psmouse i2c_core serio_raw thermal ehci_hcd intel_agp rtc_cm=
os evdev e1000e processor ata_generic button
Dec 10 00:32:10 es kernel: Pid: 11428, comm: imap Tainted: G        W  2.=
6.32 #1
Dec 10 00:32:10 es kernel: Call Trace:
Dec 10 00:32:10 es kernel:  [<c022af3d>] ? warn_slowpath_common+0x5e/0x8a=

Dec 10 00:32:10 es kernel:  [<c022af9b>] ? warn_slowpath_fmt+0x26/0x2a
Dec 10 00:32:10 es kernel:  [<c02c86c0>] ? idr_callback+0x2a/0x4b
Dec 10 00:32:10 es kernel:  [<c0336711>] ? idr_for_each+0x5a/0x91
Dec 10 00:32:10 es kernel:  [<c02c8696>] ? idr_callback+0x0/0x4b
Dec 10 00:32:10 es kernel:  [<c02c8687>] ? inotify_free_group_priv+0x12/0=
x21
Dec 10 00:32:10 es kernel:  [<c02c6f39>] ? fsnotify_final_destroy_group+0=
x16/0x1e
Dec 10 00:32:10 es kernel:  [<c02c87fc>] ? inotify_release+0x16/0x22
Dec 10 00:32:10 es kernel:  [<c02a4e06>] ? __fput+0xc0/0x16a
Dec 10 00:32:10 es kernel:  [<c02a24dc>] ? filp_close+0x4e/0x54
Dec 10 00:32:10 es kernel:  [<c02a253c>] ? sys_close+0x5a/0x8d
Dec 10 00:32:10 es kernel:  [<c0202844>] ? sysenter_do_call+0x12/0x22
Dec 10 00:32:10 es kernel: ---[ end trace 4eaa2a86a8e2da24 ]---
Dec 10 00:32:10 es kernel: entry->group=3D(null) inode=3D(null) wd=3D1024=


hth, tim

--=20
tim@klingt.org
http://tim.klingt.org

Our products just aren't engineered for security.
  Brian Valentine, Microsoft's vice president of Windows development



--------------enig2EC76720E6AFA038BC6AE198
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkshXGQACgkQdL+4qsZfVss2pwCgio5B/bulpi1UqUa7mn/z52vb
TkEAnjOx2xl3d5MTYsDEdmMdY4qSi0ak
=qMJc
-----END PGP SIGNATURE-----

--------------enig2EC76720E6AFA038BC6AE198--

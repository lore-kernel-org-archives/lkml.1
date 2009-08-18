Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbZHRMoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbZHRMoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbZHRMoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:44:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:59427 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755053AbZHRMog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:44:36 -0400
X-Authenticated: #32306085
X-Provags-ID: V01U2FsdGVkX1+LzbQqowaLXdKtDGwdRkjPNCGzB1hzYGtZ/uGfa8
	2rWrqaoIOf/y52
From: Christoph Thielecke <christoph.thielecke@gmx.de>
Reply-To: christoph.thielecke@gmx.de
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel bug 2.6.31-rc6
Date: Tue, 18 Aug 2009 14:43:39 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3992073.qbIZV5BUBL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200908181443.46652.christoph.thielecke@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3992073.qbIZV5BUBL
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello list,

I got an kernel bug using 2.6.31-rc6 (machine freeze, sysreq not working).=
=20
Interesting: I use kde3 (user crissi) and start an second xserver in=20
userspace (xephyr) (user kde-devel). I allow to write the xserver on my=20
display via xhost +.

@linus
This is different from bug before because I start there a new session via k=
dm=20
(2x xorg).


Aug 18 10:24:09 develop kernel: idr_remove called for id=3D2147483647 which=
 is=20
not allocated.
Aug 18 10:24:09 develop kernel: Pid: 17363, comm: kded4 Tainted: P         =
 =20
2.6.31-rc6 #2
Aug 18 10:24:09 develop kernel: Call Trace:
Aug 18 10:24:09 develop kernel: [<c133a0b0>] ? printk+0x18/0x20
Aug 18 10:24:09 develop kernel: [<c11d00c0>] idr_remove+0x79/0x1ad
Aug 18 10:24:09 develop kernel: [<c10db9d1>] ?=20
fsnotify_add_notify_event+0x105/0x205
Aug 18 10:24:09 develop kernel: [<c10ddce3>] inotify_remove_from_idr+0x21/0=
x34
Aug 18 10:24:09 develop kernel: [<c10de1ae>]=20
inotify_ignored_and_remove_idr+0x85/0xb7
Aug 18 10:24:09 develop kernel: [<c10dd753>] inotify_freeing_mark+0x8/0xa
Aug 18 10:24:09 develop kernel: [<c10dc3ab>]=20
fsnotify_destroy_mark_by_entry+0xf3/0x132
Aug 18 10:24:09 develop kernel: [<c10ddc82>] sys_inotify_rm_watch+0x5e/0x8d
Aug 18 10:24:09 develop kernel: [<c1003610>] sysenter_do_call+0x12/0x2c
Aug 18 10:24:55 develop kernel: idr_remove called for id=3D2147483647 which=
 is=20
not allocated.
Aug 18 10:24:55 develop kernel: Pid: 12754, comm: kded4 Tainted: P         =
 =20
2.6.31-rc6 #2
Aug 18 10:24:55 develop kernel: Call Trace:
Aug 18 10:24:55 develop kernel: [<c133a0b0>] ? printk+0x18/0x20
Aug 18 10:24:55 develop kernel: [<c11d00c0>] idr_remove+0x79/0x1ad
Aug 18 10:24:55 develop kernel: [<c10db9d1>] ?=20
fsnotify_add_notify_event+0x105/0x205
Aug 18 10:24:55 develop kernel: [<c10ddce3>] inotify_remove_from_idr+0x21/0=
x34
Aug 18 10:24:55 develop kernel: [<c10de1ae>]=20
inotify_ignored_and_remove_idr+0x85/0xb7
Aug 18 10:24:55 develop kernel: [<c10dd753>] inotify_freeing_mark+0x8/0xa
Aug 18 10:24:55 develop kernel: [<c10dc3ab>]=20
fsnotify_destroy_mark_by_entry+0xf3/0x132
Aug 18 10:24:55 develop kernel: [<c10ddc82>] sys_inotify_rm_watch+0x5e/0x8d
Aug 18 10:24:55 develop kernel: [<c1003610>] sysenter_do_call+0x12/0x2c


Best regards

Christoph
=2D-=20
Linux User Group Wernigerode
http://www.lug-wr.de/

--nextPart3992073.qbIZV5BUBL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqKof0ACgkQd9JRTD5SjRgo9QCggjLJSsUSp1sdQH6N1XoJHBuU
fdkAn0LpN/QAMBbEh5PLl2agdcKTVoij
=c2U3
-----END PGP SIGNATURE-----

--nextPart3992073.qbIZV5BUBL--

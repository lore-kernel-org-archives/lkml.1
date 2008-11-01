Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbYKAKK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbYKAKK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 06:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYKAKKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 06:10:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:51490 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751225AbYKAKKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 06:10:49 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19a9uFnck5azmkSuIJO0HK0yTMWvpsiMqMDi1M4pg
	9R4aoDKzJk6zAZ
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: task sadc:1148 blocked for more than 120 seconds.
Date: Sat, 1 Nov 2008 11:10:40 +0100
User-Agent: KMail/1.9.10
Cc: sysstat@orange.fr
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2481196.bVsk8YPEWL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811011110.45249.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2481196.bVsk8YPEWL
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hallo,

hibernating my ThinkPad T41 yesterday evening and waking it up today in the=
=20
morning I got some minutes later this in my syslog:

Nov  1 10:43:19 n22 INFO: task sadc:1148 blocked for more than 120 seconds.
Nov  1 10:43:19 n22 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.
Nov  1 10:43:19 n22 sadc          D 00000282     0  1148   1147
Nov  1 10:43:19 n22 c6403edc 00000082 c6403edc 00000282 f7f44800 003b1696=20
f7f44840 c6403edc
Nov  1 10:43:19 n22 c01ad66c 00000000 00000000 ce2cc7d0 c0129380 f7f44840=20
f5cc7ee8 003b1696
Nov  1 10:43:19 n22 f771e440 d3ed52e8 f7f44800 c01a9928 00000000 00000000=20
00000007 f78c225c
Nov  1 10:43:19 n22 Call Trace:
Nov  1 10:43:19 n22 [<c01ad66c>] log_wait_commit+0x9c/0x100
Nov  1 10:43:19 n22 [<c0129380>] autoremove_wake_function+0x0/0x50
Nov  1 10:43:19 n22 [<c01a9928>] journal_stop+0xb8/0x170
Nov  1 10:43:20 n22 [<c0179c93>] __writeback_single_inode+0x213/0x2e0
Nov  1 10:43:20 n22 [<c0147880>] generic_writepages+0x20/0x30
Nov  1 10:43:20 n22 [<c0141f22>] __filemap_fdatawrite_range+0x72/0x90
Nov  1 10:43:20 n22 [<c019bc3c>] ext3_sync_file+0x8c/0xa0
Nov  1 10:43:20 n22 [<c017cbee>] do_fsync+0x6e/0xb0
Nov  1 10:43:20 n22 [<c017cc55>] __do_fsync+0x25/0x40
Nov  1 10:43:20 n22 [<c0103e3e>] sysenter_past_esp+0x5f/0x85
Nov  1 10:43:20 n22 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D


Here are the cron jobs for the installed Gentoo package=20
app-admin/sysstat-8.0.4.1 :

n22 ~ # uname -a
Linux n22 2.6.25.19 #1 Thu Oct 23 10:35:34 CEST 2008 i686 Intel(R) Pentium(=
R)=20
M processor 1700MHz GenuineIntel GNU/Linux

n22 ~ # cat /etc/cron.d/sysstat
*/5 * * * * root /usr/lib/sa/sa1 60 5

n22 ~ # cat /etc/cron.hourly/sysstat
#!/bin/sh

/usr/lib/sa/sa2 -A


=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart2481196.bVsk8YPEWL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkMKyUACgkQhyrlCH22naM/iACgxHtEr8JCPJaxiaMSeBSbvk6e
ktYAoJwbdzwxGYeiYMuq6FXnuy1lJy0h
=6K4P
-----END PGP SIGNATURE-----

--nextPart2481196.bVsk8YPEWL--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbXEZMmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbXEZMmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 08:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbXEZMml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 08:42:41 -0400
Received: from daemonizer.de ([87.230.16.230]:37734 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbXEZMmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 08:42:40 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Oops with prism54 in 2.6.22-rc3
Date: Sat, 26 May 2007 14:42:30 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3964688.KVejmKojIB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705261442.34054.maxi@daemonizer.de>
X-Spam-Score: -4.0 (----)
X-Spam-Report: No, hits=-4.0 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.1.7-deb 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.4 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3964688.KVejmKojIB
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

when using the prism54 driver including in the 2.6.22-rc3 kernel I get this=
=20
Oops when putting the card into monitor mode:

BUG: unable to handle kernel NULL pointer dereference at virtual address=20
000001d8
 printing eip:
c0500608
*pde =3D 00000000
Oops: 0002 [#1]
PREEMPT=20
Modules linked in: fuse
CPU:    0
EIP:    0060:[<c0500608>]    Not tainted VLI
EFLAGS: 00010046   (2.6.22-rc3 #2)
EIP is at netif_rx+0x48/0xc0
eax: 00000000   ebx: c18fdbc0   ecx: c087991c   edx: c0879910
esi: 00000246   edi: f7c68010   ebp: f7fe0ba0   esp: c07bbef0
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=3Dc07ba000 task=3Dc075a280 task.ti=3Dc07ba000)
Stack: f7ec0000 00000000 c03d2b8f c07bbf24 00000082 f7c68024 f7fe0800 c18fd=
bc0=20
       00000070 00000046 00000286 00000286 00000008 00000007 0032dcd5 00000=
000=20
       f7fe0ba0 00000002 f7fe0800 c03d913d 00000000 00000000 f7f4d2c0 00000=
000=20
Call Trace:
 [<c03d2b8f>] islpci_eth_receive+0x12f/0x590
 [<c03d913d>] islpci_interrupt+0x1cd/0x280
 [<c0144e15>] handle_IRQ_event+0x25/0x50
 [<c014669c>] handle_fasteoi_irq+0x5c/0xe0
 [<c010674a>] do_IRQ+0x4a/0x80
 [<c010498f>] common_interrupt+0x23/0x28
 [<c0102b3a>] default_idle+0x2a/0x40
 [<c01023e3>] cpu_idle+0x43/0x80
 [<c07bcb2a>] start_kernel+0x21a/0x260
 [<c07bc450>] unknown_bootoption+0x0/0x260
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: c7 43 0c 00 00 00 00 c7 43 10 00 00 00 00 9c 5e fa ff 05 bc 9c 87 c0 =
a1=20
0c 99 87 c0 3b 05 c0 4a 7b c0 77 30 85 c0 74 43 8b 43 14 <ff> 80 d8 01 00 0=
0=20
a1 08 99 87 c0 ff 05 0c 99 87 c0 c7 03 04 99=20
EIP: [<c0500608>] netif_rx+0x48/0xc0 SS:ESP 0068:c07bbef0
Kernel panic - not syncing: Fatal exception in interrupt

After this the system is frozen. Using kernel 2.6.21 everything works fine,=
 I=20
can capture packets in monitor mode and do not get any Oops.

Maxi

--nextPart3964688.KVejmKojIB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWCs6Oimwv528XGERAlyFAJ9YaeDXO2R8bdKkIwQbsaWQHrqXkACgpZrP
h/G6gFBR/SoGw+EhKarqa4A=
=z5a1
-----END PGP SIGNATURE-----

--nextPart3964688.KVejmKojIB--

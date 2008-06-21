Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbYFUOKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbYFUOKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYFUOKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:10:04 -0400
Received: from [194.117.236.238] ([194.117.236.238]:38857 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYFUOKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:10:04 -0400
Date: Sat, 21 Jun 2008 17:09:27 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: tzanussi@gmail.com
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Relay buffer-only channels and its prereqs (resubmit)
Message-ID: <20080621170927.6b657d01@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/xxi_1_JW2ezu_Pni3QS67DN";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xxi_1_JW2ezu_Pni3QS67DN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello everybody,

Sorry for being so late to correct what Mathieu suggested.

Patch 1 has been acked by Mathieu. Vegard Nossum finds the 2nd patch
useful for kmemcheck.

As previously discussed, these patches allow kmemtrace to start logging
data as soon as kmem_cache_init() completes.

Please take a look and tell me what you think.


	Cheers,
	Eduard

Eduard - Gabriel Munteanu (3):
  Unignore vmlinux.lds.h from Git.
  Better interface for hooking early initcalls.
  relay: Add buffer-only channels; useful for early logging.

 .gitignore                          |    1 +
 Documentation/filesystems/relay.txt |   11 +++
 include/asm-generic/vmlinux.lds.h   |    2 +
 include/linux/init.h                |    7 ++
 include/linux/relay.h               |    5 +
 init/main.c                         |   13 +++-
 kernel/relay.c                      |  141 +++++++++++++++++++++++++++----=
----
 7 files changed, 147 insertions(+), 33 deletions(-)

--Sig_/xxi_1_JW2ezu_Pni3QS67DN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUBSF0LntxcOkuRpXptAQIfkg/+OF7es7egqHmMga95eUVvGkx6KEKRV5bV
lVfGMHyAA8HzvdRCWb4GTpSaMT3FQ/zUBL5lYEf+GIGkSfdf7K/rA0E/0Q53APCj
mlBwsbbcBGy2xhx7ivn2FovsLufQEeglmmZwmrqKxqCPHdP8Lti7GFjLraw49h36
Y7/wtJIkSmevIs2Efq4R4ZMPaz8SGZUVfARkoHljhZgTuCu66idFihXpWiCW4KbW
j++F0jtMG5wxCM8xZPyTxb3Gx16bKc+YNvbMVoFi6kJfkhLEdMBE1MLtdcfJWN42
rQRBPCyFOdd8wImwO0V1A4xjV7MQkCrkqbh8aeJX8AETIhilapDNnzqqlW8AooBd
A8z4DbX9r0n5B8G6TsRqWVpix4mKgY6KW4EFipjvfedtV+yg76jiHPf6imrlncHL
Y6SjnkyJLDB+zqIh/+TJtPW14bY1H05KoqZ/O0T/Qq09e7/Lktf/LuXczFOQj+A8
vFFjGUs/j899eS//BzaB57fQ73dPcQarks49pP8NSwU2BkIw6C0Yese9nkpE4rkI
vhaddEAbB5hBwmU1i3trGoU5rxhk7QAZyZIeAXgK6TZQrDmjPGdKxVORzJ8eWI0e
sWD0cDjtBDutOg1ZZ/YpSlPR2apywHNs/75PUKA8PEgUC1EjduUbZop3LACPO5AY
IpcPCVMesnY=
=Suqr
-----END PGP SIGNATURE-----

--Sig_/xxi_1_JW2ezu_Pni3QS67DN--

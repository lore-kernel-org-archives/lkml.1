Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbYGJOUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbYGJOUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYGJOT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:19:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:60613 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754381AbYGJOT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:19:57 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/i6xgOJgDiE99/w+0Xz2XHxyTCAoXyjzTuEPYaNv
	DRMiKRFs7k9tJB
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: UML kernel failed to start betvee 2.6.8-rc8 and current git sources
Date: Thu, 10 Jul 2008 16:19:51 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart202621813.ZLCUdcvA5Z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200807101619.54052.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart202621813.ZLCUdcvA5Z
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hm,

from v2.6.26-rc8 to v2.6.26-rc9-56-g6329d30 sth. affected UML, b/c my user =
mode linux kernel produces this :

=2E..
VFS: Mounted root (ext3 filesystem) readonly.
Registers -
        0       0x0
        1       0x0
        2       0x0
        3       0x0
        4       0x0
        5       0x0
        6       0x0
        7       0x0
        8       0x0
        9       0x0
        10      0x0
        11      0x0
        12      0x0
        13      0x0
        14      0x0
        15      0x0
        16      0x0
Kernel panic - not syncing: do_syscall_stub : PTRACE_SETREGS failed, errno =
=3D 5


EIP: 0073:[<b7eef424>] CPU: 0 Not tainted ESP: 007b:bfc0acf0 EFLAGS: 002002=
46
    Not tainted
EAX: 00000000 EBX: 00002e8f ECX: 00000013 EDX: 00002e8f
ESI: 00002e8b EDI: 00000000 EBP: 00000002 DS: 007b ES: 007b
17c6bd00:  [<080927c3>] notifier_call_chain+0x43/0x90
17c6bd24:  [<0809286e>] atomic_notifier_call_chain+0x2e/0x40
17c6bd3c:  [<08078eb6>] panic+0x76/0x110
17c6bd5c:  [<0806e4d3>] run_syscall_stub+0x2f3/0x300
17c6bd90:  [<0807044d>] write_ldt_entry+0x1ad/0x1c0
17c6bdd8:  [<08070c0e>] init_new_ldt+0x18e/0x3d0
17c6bdf0:  [<080a55a7>] __alloc_pages_internal+0x87/0x450
17c6be1c:  [<0806f105>] start_userspace+0x1a5/0x1f0
17c6be50:  [<0805ede1>] init_new_context+0x91/0x140
17c6be6c:  [<080c6789>] bprm_mm_init+0x49/0x1c0
17c6be78:  [<0806c485>] set_signals+0x25/0x30
17c6be80:  [<080be18a>] kmem_cache_alloc+0x4a/0xa0
17c6be98:  [<080c7e73>] do_execve+0x83/0x1e0
17c6bebc:  [<0805a685>] execve1+0x35/0x60
17c6bedc:  [<0805a714>] um_execve+0x14/0x50
17c6bee0:  [<080ce4cb>] dupfd+0xfb/0x130
17c6beec:  [<0805ce8f>] kernel_execve+0x3f/0x50
17c6bf08:  [<0805a302>] run_init_process+0x22/0x30
17c6bf18:  [<0805a3c6>] init_post+0xb6/0x100
17c6bf2c:  [<080496e1>] kernel_init+0x251/0x2b0
17c6bf54:  [<08055400>] tcp_congestion_default+0x0/0x20
17c6bfa4:  [<08075b36>] finish_task_switch+0x26/0x80
17c6bfbc:  [<0806b0b3>] run_kernel_thread+0x43/0x50
17c6bfd8:  [<0806b08f>] run_kernel_thread+0x1f/0x50
17c6bfe4:  [<0805be11>] new_thread_handler+0x61/0x90
17c6bfe8:  [<08049490>] kernel_init+0x0/0x2b0

Terminated

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart202621813.ZLCUdcvA5Z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkh2GokACgkQhyrlCH22naNkaACfRsB3ASYdHiiFvjhtTsE5sKkf
A1oAoIhRYBKXEhEP+ImNQUrFuAvYwHKE
=hY0a
-----END PGP SIGNATURE-----

--nextPart202621813.ZLCUdcvA5Z--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761972AbXFCNDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761972AbXFCNDD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 09:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759632AbXFCNCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 09:02:54 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:40151 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759606AbXFCNCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 09:02:53 -0400
Date: Sun, 3 Jun 2007 15:02:46 +0200
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [1/4] 2.6.22-rc3: known regressions
Message-ID: <20070603150246.5151dda6@laptop.hypervisor.org>
In-Reply-To: <465C2225.2000100@googlemail.com>
References: <465C2225.2000100@googlemail.com>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_cg5MW5v95WXuOXt=S6Qlirs";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_cg5MW5v95WXuOXt=S6Qlirs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 May 2007 14:52:53 +0200 Michal Piotrowski (MP) wrote:

MP> Here is a list of some known regressions in 2.6.22-rc3.
MP>=20
MP> Feel free to add new regressions/remove fixed etc.
MP> http://kernelnewbies.org/known_regressions

Here's another 2.6.22-rc3 regression. It was ok on 2.6.21. I believe it
triggered during: echo 0 > /proc/sys/kernel/nmi_watchdog


------------[ cut here ]------------
kernel BUG at arch/i386/kernel/cpu/perfctr-watchdog.c:126!
invalid opcode: 0000 [#1]
PREEMPT=20
Modules linked in:
CPU:    0
EIP:    0060:[<c010cae5>]    Not tainted VLI
EFLAGS: 00010286   (2.6.22-rc3 #2)
EIP is at release_evntsel_nmi+0x16/0x22
eax: 000000c1   ebx: 080f7408   ecx: c04296e0   edx: ffffff3b
esi: 00000001   edi: f69d4240   ebp: 00000002   esp: f6962f30
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process rc.M (pid: 1281, ti=3Df6962000 task=3Df706c030 task.ti=3Df6962000)
Stack: c010cb60 c010cda3 c0110abe 080f7408 f6962f64 f6962fa0 c042ab68 fffff=
fff=20
       c01853a8 080f7408 f6962f64 f6962fa0 080f7408 00000002 c042a774 f69d4=
240=20
       080f7408 c0185339 00000002 c0156d33 f6962fa0 f7fcccb4 f69d4240 fffff=
ff7=20
Call Trace:
 [<c010cb60>] single_msr_unreserve+0xd/0x1a
 [<c010cda3>] disable_lapic_nmi_watchdog+0x2b/0x39
 [<c0110abe>] proc_nmi_enabled+0xa0/0xbd
 [<c01853a8>] proc_sys_write+0x6f/0x8c
 [<c0185339>] proc_sys_write+0x0/0x8c
 [<c0156d33>] vfs_write+0x8a/0x10c
 [<c01571ef>] sys_write+0x41/0x67
 [<c0103c30>] syscall_call+0x7/0xb
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: 00 c7 04 24 f6 5d 3c c0 e8 7d e0 00 00 83 ca ff 89 d0 5a 59 c3 8b 0d =
28
6e 48 c0 31 d2 85 c9 74 0e 89 c2 2b 51 18 83 fa 42 76 04 <0f> 0b eb fe 0f b=
3 15
38 6e 48 c0 c3 8b 0d 28 6e 48 c0 31 d2 85 EIP: [<c010cae5>]
release_evntsel_nmi+0x16/0x22 SS:ESP 0068:f6962f30

Cheers,

	- Udo

--Sig_cg5MW5v95WXuOXt=S6Qlirs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGYrv2nhRzXSM7nSkRAjo1AJ0RPAoCSIswup0BQ537E3pmgWJUSACfduA+
orS0wSgoXvYFMnrF872g1ck=
=EwQ/
-----END PGP SIGNATURE-----

--Sig_cg5MW5v95WXuOXt=S6Qlirs--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765035AbYA2QKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765035AbYA2QKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760096AbYA2QKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:10:12 -0500
Received: from hydra.gt.owl.de ([195.71.99.218]:35513 "EHLO hydra.gt.owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756948AbYA2QKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:10:10 -0500
X-Greylist: delayed 2059 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2008 11:10:10 EST
Date: Tue, 29 Jan 2008 16:33:05 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Nai Xia <nai.xia@gmail.com>
Cc: k-ueda@ct.jp.nec.com, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 && -g8561b089
Message-ID: <20080129153305.GA7203@paradigm.rfc822.org>
References: <200801292201.45718.nai.xia@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <200801292201.45718.nai.xia@gmail.com>
Organization: rfc822 - pure communication
X-SpiderMe: mh-200801291622@listme.rfc822.org
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 29, 2008 at 10:01:45PM +0800, Nai Xia wrote:
>=20
> Build environment: debian sid, gcc-4.2.3, i386.
>=20
> The bug is in lately git-pull from=20
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>=20
> And it can be reproduced very easily on a machine with normal cdroms.
> It halts booting and I grabbed the bug output with an serial console.

I get this on boot on an Core Duo Lifebook E8110 with an DVD Recorder which
renders this kernel unusable:

[   40.406743] ------------[ cut here ]------------
[   40.410255] kernel BUG at drivers/ide/ide-cd.c:1726!
[   40.410255] invalid opcode: 0000 [#1] PREEMPT SMP=20
[   40.410255] Modules linked in: ehci_hcd(+) ohci1394(+) uhci_hcd(+) outpu=
t yenta_socket(+) rsrc_nonstatic irda parport_pc(+) parport mmc_core ieee13=
94 pcmcia_core sky2 ide_cd usbcore crc_ccitt
[   40.410255]=20
[   40.410255] Pid: 1115, comm: modprobe Not tainted (2.6.25-rc0 #1)
[   40.410255] EIP: 0060:[<e0055e70>] EFLAGS: 00010002 CPU: 0
[   40.410255] EIP is at cdrom_newpc_intr+0xfb/0x29f [ide_cd]
[   40.410255] EAX: 00000001 EBX: 00000002 ECX: 0000009e EDX: 00000001
[   40.410255] ESI: 00000003 EDI: c0547f18 EBP: de52bdbc ESP: de52bd8c
[   40.410255]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   40.410255] Process modprobe (pid: 1115, ti=3Dde52a000 task=3Dde616000 t=
ask.ti=3Dde52a000)
[   40.410255] Stack: c0528d00 de52bda8 df2d9600 de52bdb0 df24bc20 00000000=
 0000009e de52bdbc=20
[   40.410255]        00000050 c0547ec0 c0547f18 df24bc00 de52bdf4 c025bc76=
 00000c64 de54ab7c=20
[   40.410255]        c050b760 000200d2 c0491758 0000000e 00000202 e0055d75=
 de616000 df24d660=20
[   40.410255] Call Trace:
[   40.410255]  [<c0104f2e>] show_trace_log_lvl+0x1a/0x2f
[   40.410255]  [<c0104fde>] show_stack_log_lvl+0x9b/0xa3
[   40.410255]  [<c010508a>] show_registers+0xa4/0x1ba
[   40.410255]  [<c01052bd>] die+0x11d/0x1fe
[   40.410255]  [<c0105428>] do_trap+0x8a/0xa3
[   40.410255]  [<c0105700>] do_invalid_op+0x88/0x92
[   40.410255]  [<c037d142>] error_code+0x72/0x78
[   40.410255]  [<c025bc76>] ide_intr+0x166/0x1c9
[   40.410255]  [<c014dbee>] handle_IRQ_event+0x21/0x48
[   40.410255]  [<c014ebac>] handle_edge_irq+0xa8/0x10d
[   40.410255]  [<c0106848>] do_IRQ+0x5c/0x78
[   40.410255]  [<c010494f>] common_interrupt+0x23/0x28
[   40.410255]  [<c014207c>] sys_init_module+0x29d/0x18e1
[   40.410255]  [<c0103f3e>] sysenter_past_esp+0x5f/0x85
[   40.410255]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   40.410255] Code: f6 45 f0 08 8b 92 98 00 00 00 89 55 e8 75 3e b8 80 e5 =
4c c0 e8 81 6d 32 e0 31 c9 31 d2 89 c3 8b 45 d8 e8 bf 1e 17 e0 85 c0 74 04 =
<0f> 0b eb fe 8b 47 2c 89 da 8b 40 08 c7 40 1c 00 00 00 00 b8 80=20
[   40.410255] EIP: [<e0055e70>] cdrom_newpc_intr+0xfb/0x29f [ide_cd] SS:ES=
P 0068:de52bd8c
[   40.410255] Kernel panic - not syncing: Fatal exception in interrupt

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHn0cxUaz2rXW+gJcRAtYnAKDkPXt4BOhofRtX9tgvQEknxnC++wCgvGhC
tNRkP6/yLXyCPQ0KIJoKdDY=
=4RRj
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--

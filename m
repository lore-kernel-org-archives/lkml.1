Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbYBOSM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbYBOSM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbYBOSMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:12:19 -0500
Received: from mail.gmx.net ([213.165.64.20]:37790 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757519AbYBOSMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:12:17 -0500
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX18+KZYdKrk+4Vys/4lVtZAXsyxCKLT0OahT03e8Nm
	efNzj0AEf8MLJe
Date: Fri, 15 Feb 2008 19:12:15 +0100
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Regression: kernel 2.6.24{,.1} ahci problem, does not boot
 (resend)
Message-ID: <20080215191215.430ee2e0@highlander.home.lan>
In-Reply-To: <47B4D02E.9030101@gmail.com>
References: <20080214184700.0bd3837d@highlander.home.lan>
	<47B4D02E.9030101@gmail.com>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/YN=RmG0aoGTr9uPkO+q1kUe";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YN=RmG0aoGTr9uPkO+q1kUe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Feb 2008 08:35:10 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Malte Schr=C3=B6der wrote:
> > Hello,
> > on one of my machines neither 2.6.24 nor 2.6.24.1 work.
> > The system is 64bit on Athlon X2 and ATI-Chipset (SB600).
> >=20
> > Extract from the kernel messages during boot:
> >=20
> > [   66.943103] ahci 0000:00:12.0: controller can't do 64bit DMA, forcin=
g 32bit
> > [   66.950374] ahci 0000:00:12.0: controller can't do PMP, turning off =
CAP_PMP
> > [   67.956470] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbp=
s 0xf impl SATA mode
> > [   67.964996] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio s=
lum part
> > [   67.972820] scsi0 : ahci
> > [   67.975699] scsi1 : ahci
> > [   67.978445] scsi2 : ahci
> > [   67.981178] scsi3 : ahci
> > [   67.983949] ata1: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfad=
ffd00 irq 509
> > [   67.991825] ata2: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfad=
ffd80 irq 509
> > [   67.999729] ata3: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfad=
ffe00 irq 509
> > [   68.007619] ata4: SATA max UDMA/133 abar m1024@0xfadffc00 port 0xfad=
ffe80 irq 509
> > [   68.470669] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [   98.431945] ata1.00: qc timeout (cmd 0xec)
> > [   98.454907] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
> > [   98.461296] ata1: failed to recover some devices, retrying in 5 secs
> > [  103.916773] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [  133.878045] ata1.00: qc timeout (cmd 0xec)
> > [  133.882371] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
> > [  133.888797] ata1: failed to recover some devices, retrying in 5 secs
> > [  139.343901] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [  169.305174] ata1.00: qc timeout (cmd 0xec)
> > [  169.309534] ata1.00: failed to IDENTIFY (I/O error, err_mask=3D0x4)
> > [  169.315926] ata1: failed to recover some devices, retrying in 5 secs
> > [  174.771030] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> >=20
> > The complete boot-log (captured via serial console), lspci output,
> > output of hdparm -I and the kernel config are attached.
> >=20
> > The PC has one IDE-drive and four SATA-drives (see hdparm.txt).
> > If I wait long enough, the IDE-drive get's recognized and I can
> > continue the boot process, but the SATA-drives are never recognized.
> > The system work's fine with kernel 2.6.23.11 (later kernels not tested).
>=20
> Does irqpoll kernel parameter help?
=20
No, problem stays.

--=20
---------------------------------------
Malte Schr=C3=B6der
MalteSch@gmx.de
ICQ# 68121508
---------------------------------------


--Sig_/YN=RmG0aoGTr9uPkO+q1kUe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtdX/4q3E2oMjYtURAgrXAKDiCwsELkyVwiCGSgiNOwQx9qfK2gCghAmp
ffivnZTdi074RoHI75jB5Yc=
=6UTt
-----END PGP SIGNATURE-----

--Sig_/YN=RmG0aoGTr9uPkO+q1kUe--

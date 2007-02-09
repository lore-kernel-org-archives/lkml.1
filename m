Return-Path: <linux-kernel-owner+w=401wt.eu-S1423129AbXBIROw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423129AbXBIROw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 12:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423171AbXBIROv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 12:14:51 -0500
Received: from aybabtu.com ([69.60.117.155]:52246 "EHLO aybabtu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423129AbXBIROt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 12:14:49 -0500
From: Leopold Palomo Avellaneda <lepalom@wol.es>
Reply-To: lepalom@wol.es
To: Tejun Heo <htejun@gmail.com>
Subject: Re: Sata_via problems in a Vintage2-AE1
Date: Fri, 9 Feb 2007 18:13:57 +0100
User-Agent: KMail/1.9.5
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200702090010.06897.lepalom@wol.es> <45CC42FF.5030507@gmail.com>
In-Reply-To: <45CC42FF.5030507@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1934883.cEBtQvnG0i";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702091814.02530.lepalom@wol.es>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1934883.cEBtQvnG0i
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

A Divendres 09 Febrer 2007 10:46, Tejun Heo va escriure:
> Leopold Palomo Avellaneda wrote:
> > Dear people,
> >
> > I have a barebone Asus Vintage2-AE1 [1]. This box has a mobo Asus A8V-M=
Q.
> > The board has:
> > - the Socket 939 for AMD Athlon 64FX/Athlon 64.
> > - North Bridge: VIA K8M800
> > - South Bridge: VIA VT8251
> > - VIA Graphics Integrated
> > - IDE 2 x UltraDMA 133
> > - 4 x Serial ATA
> > ...
> >
> > I'm using the bios version 0206. The 0210 doesn't show me the vga card,
> > so I don't have graphics mode. I think that is a buggy bios.
> >
> > The bios is configured with vt8251 in AHCI mode and bios boot up
> > activated, so the hd is recognized in the beginning. I don't have any
> > raid, only one hd. The hd is a Maxtor 6V250F0.
> >
> > I'm using a debian etch but the i386 version. The only way that I can u=
se
> > the hd is using a 2.6.16 standard kernel with the modifications explain=
ed
> > in this page [2]. Basically you have to use their ahci.c and sata_via.c.
> > The modifications are small from the original code from Mr Jeff Garzik.
> >
> > I have tried to use the 2.6.18 and 2.6.20rc6 and the result is the same.
> > The kernel boots, but when arrives at the ata3,
> >
> > scsi2 : ahci
> > ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > ata3.00: qc timeout (cmd 0xec)
> > ata3.00: failed to IDENTIFY (I/O error, err_mask=3D0x104)
> > .... repeated some times ...
> > scsi3 : ahci
> > ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > scsi4 : ahci
> > ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > scsi5 : ahci
> > ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > Done.
> > Begin: Mounting root file system... ...
> > Begin: Running /scripts/local-top
> > ide0: I/O resource 0x3F6-0x3F6 not free.
> > ide0: ports already in use, skipping probe.
> > ide1: I/O resource 0x376-0x376 not free.
> > ide1: ports already in use, skipping probe.
> > Done.
> > Begin: Waiting for root file system ...
>
> It might be VIA IRQ quirk problem.
>
> 1. Does giving 'irqpoll' parameter to kernel make any difference?

yes. Now it boots. However I'm having a lot of messages:
APIC error on CPU0

and I begin to have problems with the network card.

> 2. Can you give a shot at 2.6.20?

yes, I'm doing it now.=20

Thank's a lot. But, why with irqpoll works and without no?

Leo


=2D-=20
=2D-
Linux User 152692
PGP: 0xF944807E
Catalonia

--nextPart1934883.cEBtQvnG0i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFzKvaaC7AnPlEgH4RAq+QAJsEsI+KzoVaJXDsxwBDjHfQsPTlswCgmL4c
+l94MtlXXkDtcL6BhePSNiY=
=fvhp
-----END PGP SIGNATURE-----

--nextPart1934883.cEBtQvnG0i--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbXGWH4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbXGWH4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 03:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbXGWHzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 03:55:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54677 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbXGWHzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 03:55:54 -0400
Date: Mon, 23 Jul 2007 17:56:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Dittmer <jdi@l4x.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: alpha, i386,mips,powerpc,ppc,xtensa compile brakage (was Re:
 Linus 2.6.23-rc1)
Message-Id: <20070723175602.ae2a1a32.sfr@canb.auug.org.au>
In-Reply-To: <46A45544.8090303@l4x.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	<46A45544.8090303@l4x.org>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__23_Jul_2007_17_56_02_+1000_eR4AUNcl9Xa4O_Zo"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Jul_2007_17_56_02_+1000_eR4AUNcl9Xa4O_Zo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jul 2007 09:14:12 +0200 Jan Dittmer <jdi@l4x.org> wrote:
>
> # powerpc/iseries_defconfig: broke
>=20
>    CC [M]  drivers/scsi/scsi_transport_sas.o
>    CC [M]  drivers/scsi/scsi_wait_scan.o
>    LD      drivers/scsi/ibmvscsi/built-in.o
>    CC [M]  drivers/scsi/ibmvscsi/ibmvscsi.o
> drivers/scsi/ibmvscsi/ibmvscsi.c: In function 'ibmvscsi_reset_host':
> drivers/scsi/ibmvscsi/ibmvscsi.c:517: error: implicit declaration of func=
tion 'vio_enable_interrupts'

Patch sent to Paulus today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__23_Jul_2007_17_56_02_+1000_eR4AUNcl9Xa4O_Zo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGpF8bTgG2atn1QN8RAiLVAJ9ZCYe6bLFt/3Exr7KEtZfWeduopgCdGEpV
dFQEVH6/WrNpe5993Mr0ijU=
=0lQC
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Jul_2007_17_56_02_+1000_eR4AUNcl9Xa4O_Zo--

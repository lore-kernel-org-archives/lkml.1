Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZKMW1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZKMW1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbZKMW05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:26:57 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:30269 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbZKMW04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:26:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=sotKBV3D27Lkmu5K9TkCFZ3ZzslCL686KfXKBMrsIYo8+oUHPpnT/dDtIMdxrHF1PJ
         qyWGQVL9+BWZ37fMTF2ma9khDXTn3Zeld/NhpsMn5nbtXoEcBrXpMfAmNRP7tsJ7kAbV
         hC7gZ+5ib5w4glcdUoHHG+EZXG3XeS+PZ33to=
Date: Fri, 13 Nov 2009 23:26:52 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
Message-ID: <20091113232652.5719f8a1@varda>
In-Reply-To: <20091113182515.38fb3793@lxorguk.ukuu.org.uk>
References: <4AFCC0D4.9020708@gmail.com>
	<200911131715.24377.bzolnier@gmail.com>
	<20091113182515.38fb3793@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/l+1ugFhP2WvcLvWvEZwAxHZ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/l+1ugFhP2WvcLvWvEZwAxHZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

El Fri, 13 Nov 2009 18:25:15 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> escribi=C3=B3:


>=20
> > PATA_ALI: EXPERIMENTAL
> > - ATAPI DMA is still broken
>=20
> Not experimental as we default to not doing ATAPI DMA. Glancing over the
> code I notice the ALI C2/C3 workaround probably wants adding to the old
> driver as it can do nasty things otherwise. (See the reset function in
> the pata_ali driver)

 FWIW I have a Motherboard with Ali chipset and have been using ATAPI DMA
(forcing it via proc) without issues since the DMA was disabled by default.
=20
 lspci -v
 IDE interface: ALi Corporation M5229 IDE (rev c7) (prog-if 8a [Master SecP=
 PriP])
 Subsystem: ASRock Incorporation Device 5229
 Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 21
 [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=
=3D8]
 [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=
=3D1]
 [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=
=3D8]
 [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=
=3D1]
 I/O ports at ff00 [size=3D16]
 Capabilities: <access denied>
 Kernel driver in use: pata_ali
 Kernel modules: ata_generic



>=20

> Alan
>=20

--Sig_/l+1ugFhP2WvcLvWvEZwAxHZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJK/d0sAAoJEDO4iEReSTB27oUQAMAJrOHK5GPQ1NnsMNVn1Sa2
fo14jwjkXw1ucu+3NDklfiu/xxGAWYkh8txF+1biS6RxEflzFy4+UEy+Z9FmZ+Z8
QUpBBEjZzNogkYDKWOGb5XjM/ryeEzyqxp2Fewzh8jkRrLwRSoFTHNpJyX7OL8pz
OFpc/7fEJSC+Gte0YsZRCcqk1qsTDFtcoFKMdZ8YHqBDgxPZ1Zpa+Zrrnr4UXj9a
bEw2BLzs6YOgNSPALrNqJowxiFRRcDgx2b4iDmk5fHhFDhqmrSjN1HPS7Z4tivGG
h77vwAyNwbobO2GKgTIaweC2RIrt5fK8QNmYmQan9AEHn8TJDT4Jj5UJ4INFECly
XjsWwE8VP/VG2lX85G3ZkdpjCNfOSZPE4SZBVgUCn9KGCZLtbWpYjRCljJbIFYxD
VqS3jibMnAxRo96o4VBMOo3JuyBQuUjZPkURt6VocR6WZgUb8gducviXGsYcqz+T
ngw4+uZAS754CsQ7FQcRuKsbXM/OQpUeFPeNTJN6ItqjZiF9u5tXYMJwPVNEF5Is
3SrxDOh4/W1LyXs2P0WBHg3/uE/C9ziSiwM59U2qOpBEuTZYoWs9T6muoxnJkxTv
yxdln4Ap0W1tO1HtaomuqvePK8PBgGzEvCtu/Lo/+F2DjMS1vkdCoQGQfRO4Ne0J
stEp3vBUAWwwJj73yboJ
=GFTJ
-----END PGP SIGNATURE-----

--Sig_/l+1ugFhP2WvcLvWvEZwAxHZ--

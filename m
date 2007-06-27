Return-Path: <linux-kernel-owner+w=401wt.eu-S1762487AbXF0QJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762487AbXF0QJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761109AbXF0QIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:08:52 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:49851 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761089AbXF0QIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:08:51 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: "Peer Chen" <pchen@nvidia.com>
Subject: Re: [PATCH] ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
Date: Wed, 27 Jun 2007 18:09:00 +0200
User-Agent: KMail/1.9.7
Cc: "Robert Hancock" <hancockr@shaw.ca>, "kuan luo" <kuanluo@gmail.com>,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, "Kuan Luo" <kluo@nvidia.com>
References: <fa.5TBvnXzjCgAIfcuKOLBWeXi+y5I@ifi.uio.no> <4681F06F.1050302@shaw.ca> <15F501D1A78BD343BE8F4D8DB854566B15830128@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B15830128@hkemmail01.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3690130.qVjj7LFRMG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706271809.03814.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3690130.qVjj7LFRMG
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch 27 Juni 2007 schrieb Peer Chen:
> We did the many test with the new version driver and didn't encounter
> that problem, but in certain cases, DMASETUP command packets from drive
> to the controller are corrupted, and the controller issues an R_ERR to
> the drive. Drives that comply with SATA spec will re-transmit the
> corrupted packet and normal operation continues. However, some Maxtor
> NCQ drives do not re-transmit the DMASETUP command packet, resulting in
> software timeout for this command. So if you are using the Maxtor HD and
> meet this problem,please don't enable the NCQ function.

Out of interest I tested the patch again with my Maxtor drive I mentioned i=
n=20
the other thread. Ths time it got worse. I couldn't boot anymore, ie init=20
starts some services and then dies at random places as if corrupt data was=
=20
transfered. With the previous patch the system worked, except the port=20
resets.

Anyway, I'll ask Maxtor or rather Seagate to fix their firmware pointing at=
=20
your diagnosis.

bye,
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart3690130.qVjj7LFRMG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGgoufxU2n/+9+t5gRAkWcAJ9BzdE1qReZH1dmYuINjEymvKV3fwCg3nA0
3wQFE1kaozNkwvAimaeeu50=
=hhtt
-----END PGP SIGNATURE-----

--nextPart3690130.qVjj7LFRMG--

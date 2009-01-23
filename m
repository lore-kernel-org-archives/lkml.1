Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbZAWMoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbZAWMoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 07:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbZAWMoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 07:44:05 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:44129 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753747AbZAWMoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 07:44:03 -0500
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.37,312,1231110000";   d="scan'208";a="97689592"
Date: Fri, 23 Jan 2009 13:44:00 +0100
From: markus reichelt <ml@mareichelt.de>
To: David Ronis <ronis@ronispc.chem.mcgill.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Memory not being reported
Message-id: <20090123124400.GA7871@tatooine.rebelbase.local>
Mail-followup-to: David Ronis <ronis@ronispc.chem.mcgill.ca>,
 linux-kernel@vger.kernel.org
References: <1232658295.3455.7.camel@ronispc.chem.mcgill.ca>
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=opJtzjQTFsWo+cga
Content-disposition: inline
In-reply-to: <1232658295.3455.7.camel@ronispc.chem.mcgill.ca>
Organization: still stuck in reorganization mode
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* David Ronis <ronis@ronispc.chem.mcgill.ca> wrote:

> I'm running 2.6.28.1 on an i686 (slackware-12.1 for the most part)
> box. I recently added some extra memory, expanding from 2Gb to 4.=20
> Everything works as expected except that not all of the memory
> seems to be seen.

I've got a comparable system, and could only see about 3G of the
installed 4G.


> One suspicion is that the configure option CONFIG_HIGHMEM4G=3Dy
> should be unset and the CONFIG_HIGHMEM64G  should be.

Indeed, using CONFIG_HIGHMEM64G does the trick for me, 4G usuable.

(I've also CONFIG_RESOURCES_64BIT set, maybe that's needed as well)

--=20
left blank, right bald

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFJebuQLMyTO8Kj/uQRAkrgAJ48fz3gmgMDVjSul2a5xPKa1IrOhgCdEd4U
pqMRLd2mnMfPxwW/gUll7a8=
=JBYH
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--

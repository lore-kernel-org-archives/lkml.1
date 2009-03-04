Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbZCDT0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbZCDT0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbZCDTZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:25:56 -0500
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:64293 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbZCDTZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:25:56 -0500
MIME-version: 1.0
Date: Wed, 04 Mar 2009 20:25:46 +0100
From: Frank Mehnert <Frank.Mehnert@Sun.COM>
Subject: remap_pfn_range() not suitable for physical RAM?
To: linux-kernel@vger.kernel.org
Message-id: <200903042025.46861.frank.mehnert@sun.com>
Organization: Sun Microsystems
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart3240386.e0Uf7VCB5u
Content-transfer-encoding: 7BIT
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3240386.e0Uf7VCB5u
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

since 2.6.29-rcX it seems to be not allowed anymore to use
remap_pfn_range() to remap physical RAM to userland. This restriction
applies only if CONFIG_X86_PAT is enabled. It seems that vm_insert_page()
does not have this restriction. Am I correct? And what is the reason
for this restriction?

Kind regards,

=46rank
=2D-=20
Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/

--nextPart3240386.e0Uf7VCB5u
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmu1boACgkQ6z8pigLf3EdATwCgkfFu8dJIu52dxIxrK5jKVVvV
xzsAoIsIiwUT9XLgWOcLaZH5aZ8vysUT
=AufI
-----END PGP SIGNATURE-----

--nextPart3240386.e0Uf7VCB5u--

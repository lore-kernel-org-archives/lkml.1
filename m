Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZA2IPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZA2IPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZA2IP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:15:27 -0500
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:57976 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZA2IP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:15:26 -0500
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2009 03:15:26 EST
Date: Thu, 29 Jan 2009 09:05:07 +0100
From: Frank Mehnert <Frank.Mehnert@Sun.COM>
Subject: PFs on pages pinned with get_user_pages()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200901290905.10966.frank.mehnert@sun.com>
Organization: Sun Microsystems
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart1502775.OIXW8v9tBt
Content-transfer-encoding: 7BIT
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1502775.OIXW8v9tBt
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

please could someone explain me under which circumstances a pagefault,
either generated from kernel code or from userland code, can occur on
pages which are pinned with get_user_pages()?

So far my understanding was that this can _never_ happen but I seems to
be wrong. Under high memory pressure I get PFs on such pages raised from
kernel code and the PFs are handled by do_swap_page(). When this happens,
page_count is 3 but page_mapped() returns false.

Thanks in advance,

=46rank
=2D-=20
Dr.-Ing. Frank Mehnert    Sun Microsystems    http://www.sun.com/

--nextPart1502775.OIXW8v9tBt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmBYzMACgkQ6z8pigLf3EdBewCfc40iUUy7mJUXSjOlNipHq2SY
z0YAoI9rgP/PbOckTxCq77amyAvaEdRv
=PfAF
-----END PGP SIGNATURE-----

--nextPart1502775.OIXW8v9tBt--

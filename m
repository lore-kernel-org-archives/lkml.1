Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbXIZH2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbXIZH2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 03:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbXIZH1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 03:27:52 -0400
Received: from pc175e.fzu.cz ([147.231.127.175]:59526 "EHLO postak-1.fzu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbXIZH1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 03:27:52 -0400
Message-ID: <46FA09E8.7010101@gentoo.org>
Date: Wed, 26 Sep 2007 09:27:36 +0200
From: =?ISO-8859-1?Q?Jan_Kundr=E1t?= <jkt@gentoo.org>
Organization: Gentoo
User-Agent: Thunderbird 2.0.0.6 (X11/20070812)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kswapd high CPU usage with no swap
References: <46F852B6.7030207@gentoo.org>	<20070924223444.62f0622d@bree.surriel.com>	<46F8DF55.2030905@gentoo.org> <20070925213156.68fceea2@bree.surriel.com>
In-Reply-To: <20070925213156.68fceea2@bree.surriel.com>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig364893E516F946DE84C94F2B"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig364893E516F946DE84C94F2B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Rik van Riel wrote:
> Could you try out the attached patch, too?

Sorry, I wasn't able to apply it against 2.6.22-gentoo-r3 and vanilla
2.6.22.7; I don't have the "order" member in the "struct scan_control"
and also the bit about "if (sync_writeback =3D=3D PAGEOUT_IO_SYNC &&
may_enter_fs)" was missing so there was no "else" branch to add (and it
seemd pretty significant to me). What version should I patch against?

When this is sorted out, should I keep the previous patch [1] applied as
well?

[1] http://www.redhat.com/archives/nahant-list/2006-March/msg00033.html

Cheers,
-jkt

--=20
cd /local/pub && more beer > /dev/mouth


--------------enig364893E516F946DE84C94F2B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG+gnoamXfqERyJRcRAm2rAJ0ZFKJfoP0diEtfuts3Coz14hF6ggCfRONP
WnHjP3hj8CaCnsjPYq1Ds9w=
=pmqu
-----END PGP SIGNATURE-----

--------------enig364893E516F946DE84C94F2B--

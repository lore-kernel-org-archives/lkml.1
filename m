Return-Path: <linux-kernel-owner+w=401wt.eu-S1752124AbZJKWCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbZJKWCf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZJKWCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:02:35 -0400
Received: from place.holder ([209.9.226.146]:46386 "EHLO grsecurity.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbZJKWCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:02:34 -0400
X-Greylist: delayed 1744 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Oct 2009 18:02:34 EDT
Date: Sun, 11 Oct 2009 17:32:45 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] pci: fix crash about old IA64 about pci_cfg_space_size
Message-ID: <20091011213245.GC18513@grsecurity.net>
References: <20091011074531.GA12357@grsecurity.net> <4AD1AE0D.1030007@kernel.org> <4AD24766.7050205@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2iBwrppp/7QCDedR"
Content-Disposition: inline
In-Reply-To: <4AD24766.7050205@kernel.org>
User-Agent: Mutt/1.5.9i
From: spender@grsecurity.net (Brad Spengler)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2iBwrppp/7QCDedR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Brad reported that his SGI 750 (Itanium 1) will crash from 2.6.26, and=20
> bisected

2.6.26 to 2.6.29 are fine -- the commit responsible was introduced in 2.6.3=
0,=20
so only those kernels >=3D 2.6.30 exhibit the problem.  For searching=20
purposes (so that Debian unstable etc can backport the fix to their=20
2.6.30 kernel), the error causing the panic at boot was:

General Exception: IA-64 Reserved Register/Field fault (data access) 48

and occurred a few lines after "ACPI: PCI Root Bridge [PCI0] (0000:00)"

-Brad

--2iBwrppp/7QCDedR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFK0k78mHm2SUJF1GoRApWzAJ4mK53YsHBnSx1cTjW3MUXe80f4MwCdHXZU
Sgaam9dBoIknnQL9aAlifFY=
=zQH5
-----END PGP SIGNATURE-----

--2iBwrppp/7QCDedR--

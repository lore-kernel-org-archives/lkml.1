Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029Ab0AHAWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0AHAWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359Ab0AHAWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:22:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49333 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab0AHAWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:22:44 -0500
Date: Fri, 8 Jan 2010 11:22:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: netdev@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
       isdn4linux@listserv.isdn4linux.de, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Can we remove pci_find_device() yet?
Message-Id: <20100108112236.462a3da2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Jan_2010_11_22_36_+1100_n61xPJunSsPD3M0R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Jan_2010_11_22_36_+1100_n61xPJunSsPD3M0R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This interface has been deprecated since November 2006, so can something
be done about the last users (I think only some ISDN drivers)?  Or should
we just remove the interface and mark those drivers BROKEN (and maybe
move them to staging)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Jan_2010_11_22_36_+1100_n61xPJunSsPD3M0R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktGeswACgkQjjKRsyhoI8zOnACgr/3bY0XN4/htVJZBClLknFS3
AvUAmwbRpv3TVqxGCAAT7204+h3xNlBW
=MLzZ
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Jan_2010_11_22_36_+1100_n61xPJunSsPD3M0R--

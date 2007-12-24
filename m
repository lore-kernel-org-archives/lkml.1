Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbXLXCwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbXLXCwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 21:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXLXCwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 21:52:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51095 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbXLXCwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 21:52:16 -0500
Date: Mon, 24 Dec 2007 13:52:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
       "Kyle A. Lucke" <klucke@us.ibm.com>, paulus@samba.org,
       linux-kernel@vger.kernel.org, David Gibson <dwg@au1.ibm.com>
Subject: Re: drivers/net/iseries_veth.c dubious sysfs usage
Message-Id: <20071224135208.2a29ffc0.sfr@canb.auug.org.au>
In-Reply-To: <20071213070829.GA13764@kroah.com>
References: <20071205093054.GA23229@kroah.com>
	<1196853031.6759.7.camel@concordia>
	<20071205214103.GA7074@kroah.com>
	<1196912898.14754.13.camel@concordia>
	<20071213070829.GA13764@kroah.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_Dec_2007_13_52_08_+1100_.68Y0mCcCxgBrWHK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Dec_2007_13_52_08_+1100_.68Y0mCcCxgBrWHK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 12 Dec 2007 23:08:29 -0800 Greg KH <greg@kroah.com> wrote:
>
> Hm, ok, it's odd as you are the only driver in the whole tree doing
> something like this, but it seems semi-resonable, so I can't complain :)
>=20
> I'll fix the core up to allow you to do this, thanks for the
> explanation.

So if this "seems semi-reasonable", why was the result
gregkh-driver-driver-add-driver_add_kobj-for-looney-iseries_veth-driver
containing "Hopefully no one uses this function in the future and the
iseries_veth driver authors come to their senses so I can remove this
hack..." as part of its comment.  If you expect respect, you need to
treat others the same way ...

If what the driver writers are doing is "looney" (in your opinion), then
please describe a better way of doing what they are trying to do.
Sometimes, if people have to abuse the infrastructure, it is possible that
the infrastructure is lacking?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Dec_2007_13_52_08_+1100_.68Y0mCcCxgBrWHK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHbx7dTgG2atn1QN8RAhWEAJ4ymGNuhmuHByAVk/VK3jh+K6UBYQCglLBB
WQQ4PCkw2he5ftxow1xrR2s=
=nkiS
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Dec_2007_13_52_08_+1100_.68Y0mCcCxgBrWHK--

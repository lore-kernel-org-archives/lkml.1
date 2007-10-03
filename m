Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbXJCTDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbXJCTDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 15:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXJCTDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 15:03:41 -0400
Received: from mail.vapor.com ([85.114.133.49]:40727 "EHLO mail.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbXJCTDk (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 15:03:40 -0400
X-Greylist: delayed 2114 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 15:03:40 EDT
Subject: Re: [PATCH] sky2: jumbo frame regression fix
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Bill Davidsen <davidsen@tmr.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <4703D9B6.109@tmr.com>
References: <1191372129.26233.12.camel@localhost>
	 <20071002180209.47c350a3@freepuppy.rosehill>
	 <1191375274.26233.17.camel@localhost>  <4703D9B6.109@tmr.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R68h9pbvMfJOlIsTTHGs"
Date: Wed, 03 Oct 2007 20:28:21 +0200
Message-Id: <1191436101.26233.32.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-R68h9pbvMfJOlIsTTHGs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On ons, 2007-10-03 at 14:04 -0400, Bill Davidsen wrote:
> Ian Kumlien wrote:
> > On tis, 2007-10-02 at 18:02 -0700, Stephen Hemminger wrote:
> >> Remove unneeded check that caused problems with jumbo frame sizes.
> >> The check was recently added and is wrong.
> >> When using jumbo frames the sky2 driver does fragmentation, so
> >> rx_data_size is less than mtu.
> >=20
> > Confirmed working.
> >=20
> > Now running with 9k mtu with no errors, =3D)
>=20
> Have you verified that you are actually getting jumbo packets out of the=20
> NIC? I had one machine which did standard packets silently using sky2=20
> and jumbo using sk98lin. I was looking for something else with tcpdump=20
> and got one of those WTF moments when I saw all the tiny packets.

20:27:06.542461 IP pi.local > blue.local: ICMP echo request, id 27173, seq =
42, length 8008
20:27:06.543136 IP blue.local > pi.local: ICMP echo reply, id 27173, seq 42=
, length 8008

That should solve it for us, right? =3D)

--=20
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net

--=-R68h9pbvMfJOlIsTTHGs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7-ecc0.1.6 (GNU/Linux)

iD8DBQBHA99F7F3Euyc51N8RAlk1AJ0WI17LtLVgeKsFWt4Ols8WF++RRgCfTUH7
9GATVqC1aWjgE6ZuLXECwuI=
=Xow7
-----END PGP SIGNATURE-----

--=-R68h9pbvMfJOlIsTTHGs--


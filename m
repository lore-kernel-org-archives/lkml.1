Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbZDNVXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbZDNVXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZDNVXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:23:43 -0400
Received: from home.regit.org ([91.121.73.151]:47316 "EHLO
	ks301150.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZDNVXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:23:42 -0400
X-Greylist: delayed 2191 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Apr 2009 17:23:42 EDT
Subject: Re: panic on rmmod of nf_conntrack_irc
From: Eric Leblond <eric@inl.fr>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Patrick McHardy <kaber@trash.net>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
In-Reply-To: <49E4EE9C.7040509@cosmosbay.com>
References: <20090410191736.21efab8c@mako-desktop>
	 <49E4744D.5090205@trash.net>	<49E47C2D.1050508@cosmosbay.com>
	 <49E47EA5.3060706@trash.net> <20090414211946.4ea0455e@mako-desktop>
	 <49E4EE9C.7040509@cosmosbay.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KoKp9vY0SOtVaCnm3HmS"
Organization: INL
Date: Tue, 14 Apr 2009 22:46:40 +0200
Message-Id: <1239742000.24204.9.camel@ice-age>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KoKp9vY0SOtVaCnm3HmS
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le mardi 14 avril 2009 =E0 22:14 +0200, Eric Dumazet a =E9crit :
> Mariusz Kozlowski a =E9crit :
> > On Tue, 14 Apr 2009 14:16:37 +0200
> > Patrick McHardy <kaber@trash.net> wrote:
> >=20
> >> Eric Dumazet wrote:
> >>> Patrick McHardy a =E9crit :
> >>>> Mariusz Kozlowski wrote:
> >>>>>     netfilter: nf_conntrack: use SLAB_DESTROY_BY_RCU and get rid of
> >>>>> call_rcu()
> >>>> Thanks for the report. Does this patch fix it?
> >>>>
> >>> Hi Patrick, sorry for the delay, I was in holidays.
> >> No problem, me too :)
> >>
...

>=20
> Check commit ca735b3aaa945626ba65a3e51145bfe4ecd9e222
>=20
> netfilter: use a linked list of loggers

...

> Signed-off-by: Eric Leblond <eric@inl.fr>
> Signed-off-by: Patrick McHardy <kaber@trash.net>
>=20
> It seems "struct list_head        list[NFPROTO_NUMPROTO];" is not initial=
ized in "struct nf_logger" ?
>=20
> Please try following patch ?

I've just tested your patch. Without it, I was able to trigger the bug
(modprobe ebt_ulog ; rmmod ebt_ulog). All run cleanly with it.

All my apologies for having forgot to do this test.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--=-KoKp9vY0SOtVaCnm3HmS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJ5PYtnxA7CdMWjzIRAv85AJsH8FxtF/xeSQqSYLOH0H8SAlTjngCfeuJW
XHMd3z9oPyOtTEJ+jezdJRM=
=83kK
-----END PGP SIGNATURE-----

--=-KoKp9vY0SOtVaCnm3HmS--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYHKXgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYHKXgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYHKXgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:36:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37858 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbYHKXgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:36:41 -0400
Date: Tue, 12 Aug 2008 09:36:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Steve French <sfrench@us.ibm.com>
Subject: Re: Resolved merge conflicts in next-creds
Message-Id: <20080812093624.de7d4ad8.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LRH.1.10.0808120751001.10017@tundra.namei.org>
References: <alpine.LRH.1.10.0808110950530.3636@tundra.namei.org>
	<20080811101602.09555609.sfr@canb.auug.org.au>
	<20080811153536.02ac0561.sfr@canb.auug.org.au>
	<alpine.LRH.1.10.0808120751001.10017@tundra.namei.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Aug_2008_09_36_24_+1000_b1X+p3.NOV9+.dA="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Aug_2008_09_36_24_+1000_b1X+p3.NOV9+.dA=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James, David,

On Tue, 12 Aug 2008 07:53:40 +1000 (EST) James Morris <jmorris@namei.org> w=
rote:
>
> We have tried this approach thus far without success, although perhaps no=
w=20
> the code has been in linux-next and you've come to the same conclusion, w=
e=20
> could try again.
>=20
> David, if you want to make a minimal API-only patch set, I'll can stage i=
t=20
> and push to Linus.

The important thing (and what is different in what I have proposed) is
that what you are asking Linus to take here has zero impact (i.e. you just
add a header file that noone uses and whose contents are clearly noops)
and then it is very obvious that when people start to use it, the changes
really cannot introduce a regression.

Of course, Linus has to be convinced that the long term API change is
sensible as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Aug_2008_09_36_24_+1000_b1X+p3.NOV9+.dA=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkigzPgACgkQjjKRsyhoI8wJvgCgt4pniPwJ2HKBfdeRy/n4wVYN
EdgAnjL7v32l6GDO4mYy+vJ6LonagE1o
=G5sd
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Aug_2008_09_36_24_+1000_b1X+p3.NOV9+.dA=--

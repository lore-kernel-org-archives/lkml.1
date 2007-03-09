Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbXCITf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbXCITf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767517AbXCITf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:35:27 -0500
Received: from lug-owl.de ([195.71.106.12]:39178 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbXCITfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:35:25 -0500
Date: Fri, 9 Mar 2007 20:35:24 +0100
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       rmk@arm.linux.org.uk, sam@ravnborg.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Complain about missing system calls.
Message-ID: <20070309193524.GX18564@lug-owl.de>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
	rmk@arm.linux.org.uk, sam@ravnborg.org, linux-arch@vger.kernel.org
References: <1173394873.3461.510.camel@pmac.infradead.org> <p737itqbdnl.fsf@bingen.suse.de> <20070309163805.GV18564@lug-owl.de> <20070309190051.GA20521@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1RhGCd1AsoFHGRHc"
Content-Disposition: inline
In-Reply-To: <20070309190051.GA20521@one.firstfloor.org>
X-Operating-System: Linux mail 2.6.12.3lug-owl 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--1RhGCd1AsoFHGRHc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-09 20:00:51 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> > Not everybody has a simple indexed list of pointers :)  For example,
> > for vax-linux, we use a struct per syscall with the expected number of
> > on-stack longwords for the call.
> >=20
> > So if something "new" is coming up, please keep in mind that it should
> > be flexible enough to represent that. :)
>=20
> Are there plans to merge vax any time soon to mainline?=20

Well...  That depends :)  For now, I'd prefer to stay out of mainline,
until we're having gcc-trunk with a current GNU libc up'n'running.
Until then, I plan to at least break the complete ABI once (drop old
syscals and _only_ wire up their modern counterparts.)

> Normally we don't care very much about out of tree code, especially
> if it adds complexity like this.

Sure, but at least mentioning that there's more than only a simple
table of function pointers may or may not help to *plan* the code to
fit future needs.

> But I suspect s390 would need number of arguments anyways.

Any they're already merged. Yay :)

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
  Signature of:                           Wenn ich wach bin, tr=C3=A4ume ic=
h.
  the second  :

--1RhGCd1AsoFHGRHc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF8bb8Hb1edYOZ4bsRAudgAJ0e9E00kfFWDmaVhFGsYPn40r4GzgCeOjeF
Tlc1fPEqvles7f9IUqYRw4o=
=2Dxi
-----END PGP SIGNATURE-----

--1RhGCd1AsoFHGRHc--

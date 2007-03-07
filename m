Return-Path: <linux-kernel-owner+w=401wt.eu-S1161329AbXCGIwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161329AbXCGIwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 03:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161334AbXCGIwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 03:52:04 -0500
Received: from ozlabs.org ([203.10.76.45]:46061 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161329AbXCGIwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 03:52:03 -0500
Subject: Re: [PATCH 2/3] msi:  Fixup the msi enable/disable logic
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <m1wt1td41h.fsf@ebiederm.dsl.xmission.com>
References: <m1tzx7l7z2.fsf@ebiederm.dsl.xmission.com>
	 <m1ps7vl7rr.fsf@ebiederm.dsl.xmission.com>
	 <m1lkijl7ms.fsf_-_@ebiederm.dsl.xmission.com>
	 <1172802408.518.44.camel@concordia.ozlabs.ibm.com>
	 <m1wt1td41h.fsf@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TKacp1DN+6MWkH/ELCV2"
Date: Wed, 07 Mar 2007 09:51:56 +0100
Message-Id: <1173257516.5101.13.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TKacp1DN+6MWkH/ELCV2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-06 at 22:19 -0700, Eric W. Biederman wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
>=20
> >
> > Hi Eric, comments below ..
> >
> >
> > I get the reasoning for disabling MSI before we start writing back the
> > config space, but don't we want to re-enable MSI on the way out?
>=20
> We are restoring the entire msi flags register which includes the enable =
bit,
> setting it a second time is gratuitous.
>=20
> In addition if we are restoring the register when the enable bit is not s=
et.
> (because we don't have a mask bit) enabling the msi state is actually
> the wrong thing to do.    But I admit that case can only happen after
> the additions in my last patch.

Yeah, duh.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-TKacp1DN+6MWkH/ELCV2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBF7n0sdSjSd0sB4dIRAohDAKCExMkrXIuGIkrPuQvidwPHRdA8fgCcDj8G
qxpu9LDrLyrtCauJoOPYFbQ=
=xX1j
-----END PGP SIGNATURE-----

--=-TKacp1DN+6MWkH/ELCV2--


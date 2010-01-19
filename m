Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152Ab0ASXpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab0ASXpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 18:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995Ab0ASXpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 18:45:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40792 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab0ASXpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:45:31 -0500
Date: Wed, 20 Jan 2010 10:45:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: linux-next: driver-core tree build warning
Message-Id: <20100120104525.752a790f.sfr@canb.auug.org.au>
In-Reply-To: <20100119210417.GC10928@kroah.com>
References: <20100119172741.2dd81553.sfr@canb.auug.org.au>
	<20100119210417.GC10928@kroah.com>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jan_2010_10_45_25_+1100_cdFO6zYjixd2lCVP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jan_2010_10_45_25_+1100_cdFO6zYjixd2lCVP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 19 Jan 2010 13:04:17 -0800 Greg KH <greg@kroah.com> wrote:
>
> On Tue, Jan 19, 2010 at 05:27:41PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> >=20
> > Today's linux-next build (powerpc ppc64_defconfig) produced this warnin=
g:
> >=20
> > drivers/base/cpu.c:264: warning: initialization from incompatible point=
er type
> > drivers/base/cpu.c:265: warning: initialization from incompatible point=
er type
> >=20
> > Introduced by commit 380567d3dc35a62f5cc0ec640a45dfc238238417 ("sysdev:
> > Convert node driver")?
>=20
> No, I don't think that patch causes the warning, I can't duplicate it
> here.
>=20
> I don't know what patch causes that problem, as I can't duplicate it in
> my tree at all.  Maybe some 'const' patch snuck in from some other tree?
>=20
> strange,

OK, if it is still there today, I will look deeper.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jan_2010_10_45_25_+1100_cdFO6zYjixd2lCVP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktWRBUACgkQjjKRsyhoI8xY5wCeJ2KCJqpF6JnaufpVhEgJ6Pqo
MYoAnRDyoTO6rbHE2qUoc/PzpSSjFeIN
=WIrl
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jan_2010_10_45_25_+1100_cdFO6zYjixd2lCVP--

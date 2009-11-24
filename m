Return-Path: <linux-kernel-owner+w=401wt.eu-S932633AbZKXKOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbZKXKOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932622AbZKXKOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:14:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44599 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555AbZKXKOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:14:32 -0500
Date: Tue, 24 Nov 2009 21:14:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: mfd tree build failure
Message-Id: <20091124211433.cd1b7e96.sfr@canb.auug.org.au>
In-Reply-To: <20091124095715.GA20505@rakim.wolfsonmicro.main>
References: <20091124163753.381d9a83.sfr@canb.auug.org.au>
	<20091124095715.GA20505@rakim.wolfsonmicro.main>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Nov_2009_21_14_33_+1100_eAq8oZ7q6CSvbx_X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Nov_2009_21_14_33_+1100_eAq8oZ7q6CSvbx_X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Tue, 24 Nov 2009 09:57:16 +0000 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> There's something more seriously wrong than the select with your config
> here - the driver depends on (rather than selecting) I2C and you're also
> seeing undefined references to the I2C API.  The select on MFD_CORE
> should also be forcing that to be built in (it does normally).
>=20
> Could you please post the actual configuration you're using?  I suspect
> some Kbuild bug has been triggered here...

Sorry, I don't have the actual config (as I overwrite my build directory
between each merge).  However, if I checkout the mfd tree (alone -
nothing else in linux-next) and do "make ARCH=3Dx86_64 allmodconfig", I get
the following in my .config:

CONFIG_I2C=3Dm
CONFIG_MFD_CORE=3Dm
CONFIG_MFD_WM831X=3Dy

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Nov_2009_21_14_33_+1100_eAq8oZ7q6CSvbx_X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksLsgkACgkQjjKRsyhoI8zcMwCfQDe0vsAT9kS6udpkZBqoiHFF
omIAoJLvB3vtFnYNtJ4OkRYjPumZKjbw
=O6Nh
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Nov_2009_21_14_33_+1100_eAq8oZ7q6CSvbx_X--

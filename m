Return-Path: <linux-kernel-owner+w=401wt.eu-S1756994AbZEDXtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbZEDXtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZEDXtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:49:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33406 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbZEDXtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:49:08 -0400
Date: Tue, 5 May 2009 09:48:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Paul Mackerras <paulus@samba.org>, Roel Kluin <roel.kluin@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hvcs: remove driver_data direct access of struct device
Message-Id: <20090505094845.6e9b5bab.sfr@canb.auug.org.au>
In-Reply-To: <20090504195801.GA22677@kroah.com>
References: <20090504195801.GA22677@kroah.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_May_2009_09_48_45_+1000_lzioYYRagQOGh_Q4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_May_2009_09_48_45_+1000_lzioYYRagQOGh_Q4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 4 May 2009 12:58:01 -0700 Greg Kroah-Hartman <gregkh@suse.de> wrote:
>
> From: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> In the near future, the driver core is going to not allow direct access
> to the driver_data pointer in struct device.  Instead, the functions
> dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> have been around since the beginning, so are backwards compatible with
> all older kernel versions.
>=20
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Roel Kluin <roel.kluin@gmail.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_May_2009_09_48_45_+1000_lzioYYRagQOGh_Q4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn/ft0ACgkQjjKRsyhoI8xtFgCcD/hHJ7G7VDV4FHx+R9XIGlsV
kBYAoJ8+qNjH7aBdr/9UEmZUYOOZDuMz
=H5Ym
-----END PGP SIGNATURE-----

--Signature=_Tue__5_May_2009_09_48_45_+1000_lzioYYRagQOGh_Q4--

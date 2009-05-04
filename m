Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbZEDXys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbZEDXys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 19:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbZEDXyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 19:54:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46743 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbZEDXyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 19:54:24 -0400
Date: Tue, 5 May 2009 09:53:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, Paul Mackerras <paulus@samba.org>,
       Matthias Fuchs <mfuchs@ma-fu.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of_serial: remove driver_data direct access of struct
 device
Message-Id: <20090505095332.f9c9fbd1.sfr@canb.auug.org.au>
In-Reply-To: <20090504201323.GA23069@kroah.com>
References: <20090504201323.GA23069@kroah.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_May_2009_09_53_32_+1000_4XdpxdTR8/3rLoRc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_May_2009_09_53_32_+1000_4XdpxdTR8/3rLoRc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 4 May 2009 13:13:23 -0700 Greg Kroah-Hartman <gregkh@suse.de> wrote:
>
> From: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> In the near future, the driver core is going to not allow direct access
> to the driver_data pointer in struct device.  Instead, the functions
> dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> have been around since the beginning, so are backwards compatible with
> all older kernel versions.
>=20
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Matthias Fuchs <mfuchs@ma-fu.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_May_2009_09_53_32_+1000_4XdpxdTR8/3rLoRc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn/f/wACgkQjjKRsyhoI8yNRACfTtlkN79e47ldcor8eHdA9jcP
620AnjvnXX5f+iCmn46aRG3uFkxJ7t/l
=URi3
-----END PGP SIGNATURE-----

--Signature=_Tue__5_May_2009_09_53_32_+1000_4XdpxdTR8/3rLoRc--

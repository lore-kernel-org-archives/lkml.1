Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbZE0B6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbZE0B6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbZE0B55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:57:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39381 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbZE0B55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:57:57 -0400
Date: Wed, 27 May 2009 11:57:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, sameo@linux.intel.com,
       holtmann@linux.intel.com, yi.zhu@intel.com,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com, greg@kroah.com
Subject: Re: [PATCH] firmware: Allocate firmware id dynamically
Message-Id: <20090527115748.9ff0bad1.sfr@canb.auug.org.au>
In-Reply-To: <20090526132351.9805f1e8.akpm@linux-foundation.org>
References: <20090526140423.GA14683@sortiz.org>
	<ac3eb2510905260711hb273541i8d69128b88933f7f@mail.gmail.com>
	<20090526132351.9805f1e8.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_May_2009_11_57_48_+1000_mv6k7d0UV6MmGsCk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_May_2009_11_57_48_+1000_mv6k7d0UV6MmGsCk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 26 May 2009 13:23:51 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> > > Please note that we have to keep the FIRMWARE_NAME_MAX definition aro=
und as
> > > some drivers rely on it.
> >=20
> > I think the 6 files should be converted, and FIRMWARE_NAME_MAX
> > removed, otherwise people will keep copying that crap around.
> >=20
> >   drivers/pcmcia/ds.c
> >   drivers/usb/atm/ueagle-atm.c
> >   drivers/net/wireless/libertas/if_usb.c
> >   drivers/net/wireless/libertas/if_spi.c
> >   drivers/media/dvb/dvb-usb/dvb-usb.h
> >   drivers/media/common/tuners/tuner-xc2028.c
>=20
> Yep.

$ git grep -l -w FIRMWARE_NAME_MAX next-20090526=20
next-20090526:drivers/base/firmware_class.c
next-20090526:drivers/media/common/tuners/tuner-xc2028.c
next-20090526:drivers/media/dvb/dvb-usb/dvb-usb.h
next-20090526:drivers/net/wireless/libertas/if_spi.c
next-20090526:drivers/net/wireless/libertas/if_usb.c
next-20090526:drivers/net/wireless/p54/p54usb.c
next-20090526:drivers/pcmcia/ds.c
next-20090526:drivers/usb/atm/ueagle-atm.c
next-20090526:include/linux/firmware.h
next-20090526:samples/firmware_class/firmware_sample_firmware_class.c

Its already started ...

/me looks forward to more breakage in -next :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__27_May_2009_11_57_48_+1000_mv6k7d0UV6MmGsCk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkocnhwACgkQjjKRsyhoI8zDmACgpeFlrhZL0mBr7WwZUislCAog
COwAn0+kxfwodyC9OXeaKUlOqgauR6ZU
=Al9+
-----END PGP SIGNATURE-----

--Signature=_Wed__27_May_2009_11_57_48_+1000_mv6k7d0UV6MmGsCk--

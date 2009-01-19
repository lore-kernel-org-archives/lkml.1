Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbZASDyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbZASDyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 22:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757891AbZASDxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 22:53:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51425 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757725AbZASDxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 22:53:52 -0500
Date: Mon, 19 Jan 2009 14:53:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
Message-Id: <20090119145345.ccc52374.sfr@canb.auug.org.au>
In-Reply-To: <1232332240.3129.8.camel@localhost.localdomain>
References: <1232273454.23100.9.camel@localhost.localdomain>
	<20090119095035.bf9d0e7c.sfr@canb.auug.org.au>
	<1232332240.3129.8.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_Jan_2009_14_53_45_+1100_2Jz+g1YaqN++ndVM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Jan_2009_14_53_45_+1100_2Jz+g1YaqN++ndVM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jaswinder,

On Mon, 19 Jan 2009 08:00:40 +0530 Jaswinder Singh Rajput <jaswinder@kernel=
.org> wrote:
>
> On Mon, 2009-01-19 at 09:50 +1100, Stephen Rothwell wrote:
> > Hi Jaswinder,
> >=20
> > On Sun, 18 Jan 2009 15:40:54 +0530 Jaswinder Singh Rajput <jaswinder@ke=
rnel.org> wrote:
> > >
> > > diff --git a/include/linux/raw.h b/include/linux/raw.h
> > > index 62d543e..3898e30 100644
> > > --- a/include/linux/raw.h
> > > +++ b/include/linux/raw.h
> > > @@ -13,6 +13,10 @@ struct raw_config_request
> > >  	__u64	block_minor;
> > >  };
> > > =20
> > > +#ifdef __KERNEL__
> > >  #define MAX_RAW_MINORS CONFIG_MAX_RAW_DEVS
> > > +#else /* __KERNEL__ */
> > > +#define MAX_RAW_MINORS 0
> > > +#endif /* __KERNEL__ */
> > > =20
> > >  #endif /* __LINUX_RAW_H */
> >=20
> > Since MAX_RAW_MINORS has only one user (drivers/char/raw.c), why not
> > just remove the define from here and add it it there?
> >=20
>=20
> Already fixed in v3 as pointed by Ingo.

Again I was suggesting that the whole #define line could be moved to the
only C files it is used in.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Jan_2009_14_53_45_+1100_2Jz+g1YaqN++ndVM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklz+UkACgkQjjKRsyhoI8wfjgCdFiJViLVyUJtOh4IJxY/74roy
wM0AnjuL/ngeqAD1eb/MUjC9P8PYyRXm
=BTFV
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Jan_2009_14_53_45_+1100_2Jz+g1YaqN++ndVM--

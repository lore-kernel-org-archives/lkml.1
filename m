Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbXFJNOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbXFJNOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 09:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXFJNOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 09:14:06 -0400
Received: from lug-owl.de ([195.71.106.12]:52214 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbXFJNOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 09:14:05 -0400
Date: Sun, 10 Jun 2007 15:14:02 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Andi Drebes <lists-receive@programmierforen.de>,
       kernel-janitors@lists.osdl.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/isdn/hisax: ARRAY_SIZE instead of sizeof
Message-ID: <20070610131402.GR2649@lug-owl.de>
Mail-Followup-To: Andi Drebes <lists-receive@programmierforen.de>,
	kernel-janitors@lists.osdl.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <200706101235.09578.lists-receive@programmierforen.de> <20070610131122.GB3588@pingi.kke.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i+yzTqNyNhelWXoM"
Content-Disposition: inline
In-Reply-To: <20070610131122.GB3588@pingi.kke.suse.de>
X-Operating-System: Linux mail 2.6.18-4-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--i+yzTqNyNhelWXoM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-06-10 15:11:22 +0200, Karsten Keil <kkeil@suse.de> wrote:
> > --- a/drivers/isdn/hisax/callc.c
> > +++ b/drivers/isdn/hisax/callc.c
> > @@ -834,7 +834,7 @@ static struct FsmNode fnlist[] __initdata =3D
> >  };
> >  /* *INDENT-ON* */
> > =20
> > -#define FNCOUNT (sizeof(fnlist)/sizeof(struct FsmNode))
> > +#define FNCOUNT ARRAY_SIZE(fnlist)
> > =20
> >  int __init
> >  CallcNew(void)
>
> This is OK, thanks for changing.

I'd suggest to not use another define, but use ARRAY_SIZE(foo)
_instead of_ eg. FNCOUNT.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:           Ich hatte in letzter Zeit ein bi=C3=9Fchen viel Rea=
litycheck.
the second  :               Langsam m=C3=B6chte ich mal wieder weitertr=C3=
=A4umen k=C3=B6nnen.
                             -- Maximilian Wilhelm (18. Mai 2006, #lug-owl.=
de)

--i+yzTqNyNhelWXoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGa/kaHb1edYOZ4bsRAqieAJ0eM98JfEmBWarZhnUJSXMa/RzFfwCfcrXN
4TaVWO+fN9Dc9Fpsiwpi3yg=
=gzOs
-----END PGP SIGNATURE-----

--i+yzTqNyNhelWXoM--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbXFKS7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbXFKS7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbXFKS7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:59:25 -0400
Received: from lug-owl.de ([195.71.106.12]:51571 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbXFKS7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:59:23 -0400
Date: Mon, 11 Jun 2007 20:59:22 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Andi Drebes <lists-receive@programmierforen.de>,
       kernel-janitors@lists.osdl.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Darren Jenkins <darrenrjenkins@gmail.com>
Subject: Re: [KJ] Re: [PATCH] drivers/isdn/hisax: ARRAY_SIZE instead of sizeof
Message-ID: <20070611185922.GC22027@lug-owl.de>
Mail-Followup-To: Andi Drebes <lists-receive@programmierforen.de>,
	kernel-janitors@lists.osdl.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Darren Jenkins <darrenrjenkins@gmail.com>
References: <200706101235.09578.lists-receive@programmierforen.de> <20070610131122.GB3588@pingi.kke.suse.de> <20070610131402.GR2649@lug-owl.de> <200706111120.07730.lists-receive@programmierforen.de> <82faac5b0706110525s56bade43rb24619b54687770d@mail.gmail.com> <20070611174706.GA9150@pingi.kke.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Content-Disposition: inline
In-Reply-To: <20070611174706.GA9150@pingi.kke.suse.de>
X-Operating-System: Linux mail 2.6.18-4-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-06-11 19:47:06 +0200, Karsten Keil <kkeil@suse.de> wrote:
> diff --git a/drivers/isdn/hisax/callc.c b/drivers/isdn/hisax/callc.c
> index 7c56c44..0b9ed8e 100644
> --- a/drivers/isdn/hisax/callc.c
> +++ b/drivers/isdn/hisax/callc.c
> @@ -834,8 +834,6 @@ static struct FsmNode fnlist[] __initdata =3D
>  };
>  /* *INDENT-ON* */
> =20
> -#define FNCOUNT (sizeof(fnlist)/sizeof(struct FsmNode))
> -
>  int __init
>  CallcNew(void)
>  {
> @@ -843,7 +841,7 @@ CallcNew(void)
>  	callcfsm.event_count =3D EVENT_COUNT;
>  	callcfsm.strEvent =3D strEvent;
>  	callcfsm.strState =3D strState;
> -	return FsmNew(&callcfsm, fnlist, FNCOUNT);
> +	return FsmNew(&callcfsm, fnlist, ARRAY_SIZE(fnlist));
>  }
> =20
>  void

I think that's really a nice improvement :)  Thanks for the work,

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:           Ich hatte in letzter Zeit ein bi=C3=9Fchen viel Rea=
litycheck.
the second  :               Langsam m=C3=B6chte ich mal wieder weitertr=C3=
=A4umen k=C3=B6nnen.
                             -- Maximilian Wilhelm (18. Mai 2006, #lug-owl.=
de)

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGbZuKHb1edYOZ4bsRArFXAJ0bbLgx4ipZejqnDvIdUgOx+QoxNACgjlrG
UQ453c4D4Wyw6R+ih9fi6T8=
=+Hgy
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--

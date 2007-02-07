Return-Path: <linux-kernel-owner+w=401wt.eu-S1422760AbXBGUQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422760AbXBGUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 15:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422763AbXBGUQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 15:16:27 -0500
Received: from lug-owl.de ([195.71.106.12]:45125 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422760AbXBGUQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 15:16:26 -0500
Date: Wed, 7 Feb 2007 21:16:24 +0100
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linux-Input <linux-input@atrey.karlin.mff.cuni.cz>,
       James Simmons <jsimmons@infradead.org>
Subject: Re: [PATCH] input: Schedule removal of compaq touchscreen emulation (tsdev.c)
Message-ID: <20070207201624.GF23849@lug-owl.de>
Mail-Followup-To: Richard Purdie <rpurdie@rpsys.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Linux-Input <linux-input@atrey.karlin.mff.cuni.cz>,
	James Simmons <jsimmons@infradead.org>
References: <1170780159.5826.71.camel@localhost.localdomain> <20070206205202.fde782ce.akpm@linux-foundation.org> <1170843826.5920.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ls2Gy6y7jbHLe9Od"
Content-Disposition: inline
In-Reply-To: <1170843826.5920.23.camel@localhost.localdomain>
X-Operating-System: Linux mail 2.6.12.3lug-owl 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Ls2Gy6y7jbHLe9Od
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-07 10:23:46 +0000, Richard Purdie <rpurdie@rpsys.net> wrote:
> On Tue, 2007-02-06 at 20:52 -0800, Andrew Morton wrote:
> > On Tue, 06 Feb 2007 16:42:39 +0000 Richard Purdie <rpurdie@rpsys.net> w=
rote:
> --- linux.orig/drivers/input/tsdev.c	2007-01-18 00:52:44.000000000 +0000
> +++ linux/drivers/input/tsdev.c	2007-02-07 09:32:15.000000000 +0000
> @@ -151,6 +151,10 @@ static int tsdev_open(struct inode *inod
>  	int i =3D iminor(inode) - TSDEV_MINOR_BASE;
>  	struct tsdev_list *list;
> =20
> +	printk(KERN_WARNING "tsdev (compaq touchscreen emulation) is scheduled "
> +		"for removal.\nSee Documentation/feature-removal-schedule.txt "
> +		"for details.\n");
> +
>  	if (i >=3D TSDEV_MINORS || !tsdev_table[i & TSDEV_MINOR_MASK])
>  		return -ENODEV;
> =20

What about a hugh annoying mdelay()?

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of: 23:53 <@jbglaw> So, ich kletter' jetzt mal ins Bett.
the second  : 23:57 <@jever2> .oO( kletter ..., hat er noch Gitter vorm Bet=
t, wie fr=C3=BCher meine Kinder?)
              00:00 <@jbglaw> jever2: *patsch*
              00:01 <@jever2> *aua*, wof=C3=BCr, Gedanken sind frei!
              00:02 <@jbglaw> Nee, freie Gedanken, die sind seit 1984 doch =
aus!
              00:03 <@jever2> 1984? ich bin erst seit 1985 verheiratet!

--Ls2Gy6y7jbHLe9Od
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFFyjOYHb1edYOZ4bsRAqD2AJ0cbFuxSh3VRDEuIeyocUQgL8ZC4ACfVrJN
xGiic1LqBt6iX49w0y0CqkQ=
=TVw+
-----END PGP SIGNATURE-----

--Ls2Gy6y7jbHLe9Od--

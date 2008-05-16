Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbYEPUKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbYEPUKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYEPUKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:10:36 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:46280 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYEPUKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:10:35 -0400
X-Greylist: delayed 1416 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2008 16:10:35 EDT
Date: Fri, 16 May 2008 21:46:25 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Herbert Xu <herbert@gondor.apana.org.au>, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: IPv6 slab leak (was: Re: dst cache overflow)
Message-ID: <20080516194625.GA21570@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-net@vger.kernel.org,
	linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>
References: <20071214172945.GA10809@yamamaya.is-a-geek.org> <E1J3QWn-0006sJ-00@gondolin.me.apana.org.au> <20071215100857.GA29839@yamamaya.is-a-geek.org> <20071216073533.GA2706@gondor.apana.org.au> <20071216083828.GA512@yamamaya.is-a-geek.org> <20080317012513.GA3139@yamamaya.is-a-geek.org> <20080318185914.GA9275@yamamaya.is-a-geek.org> <20080323092125.GB2950@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <20080323092125.GB2950@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Tobias Diedrich wrote:
> Tobias Diedrich wrote:
> > Tobias Diedrich wrote:
> >=20
> > > just a reminder, the server is now running 2.6.24 and the leak is
> > > still there.  I noticed there is a slab leak debug option and turned
> > > it on, results should be visible in a few days I guess.

I'm upgrading to 2.6.25.4 now and I hope that "sit: Add missing
kfree_skb() on pskb_may_pull() failure." finally fixes the bug. :)
There also was some IPv6 related leak-fix in 2.6.24.something IIRC,
but that one did not help unfortunately.

Cheers,

--=20
Tobias						PGP: http://9ac7e0bc.uguu.de
=E3=81=93=E3=81=AE=E3=83=A1=E3=83=BC=E3=83=AB=E3=81=AF=E5=8D=81=E5=89=B2=E5=
=86=8D=E5=88=A9=E7=94=A8=E3=81=95=E3=82=8C=E3=81=9F=E3=83=93=E3=83=83=E3=83=
=88=E3=81=A7=E4=BD=9C=E3=82=89=E3=82=8C=E3=81=A6=E3=81=84=E3=81=BE=E3=81=99=
=E3=80=82

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFILeSRzQZOfTz8JZwRAvkJAJ4oVQwpcfB7hOjGmqA1DlNfXTxxDQCfQy/Z
DZ4dRlcqGy+UcUS6n3xQXnY=
=MHju
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZDVS5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZDVS5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 14:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZDVS45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 14:56:57 -0400
Received: from systemlinux.org ([83.151.29.59]:37360 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbZDVS45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 14:56:57 -0400
Date: Wed, 22 Apr 2009 20:50:07 +0200
From: Andre Noll <maan@systemlinux.org>
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bill Davidsen <davidsen@tmr.com>,
       Matti Aarnio <matti.aarnio@zmailer.org>, Jesper Juhl <jj@chaosbits.net>,
       Prakash Punnoor <prakash@punnoor.de>, Michael Tokarev <mjt@tls.msk.ru>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
Subject: Re: Proposal: make RAID6 code optional
Message-ID: <20090422185007.GE13280@skl-net.de>
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net> <20090418145850.GD28512@mea-ext.zmailer.org> <49EDD11E.2030309@tmr.com> <49EE00F9.6090000@zytor.com> <20090422180051.GD13280@skl-net.de> <87vdowlevi.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lb0e7rgc7IsuDeGj"
Content-Disposition: inline
In-Reply-To: <87vdowlevi.fsf@frosties.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lb0e7rgc7IsuDeGj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20:31, Goswin von Brederlow wrote:
> > Really? Easier than keeping only two 256-byte arrays for exp() and
> > log() and use these at runtime to populate the (dynamically allocated)
> > 64K GF multiplication table? That seems to be really simple and would
> > still shave off 64K of kernel memory for raid5-only users.
> >
> > Andre
>=20
> Oh, you mean when the first raid6 device is started and not when the
> module is loaded.

Yes, that's what I was trying to say.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Lb0e7rgc7IsuDeGj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJ72bfWto1QDEAkw8RAjbqAJ98LnuA3C5ltc+rq34W/eLSCUTiSACgiuYj
Il/XAF5dCal5wiQGoN/ElwI=
=TuCF
-----END PGP SIGNATURE-----

--Lb0e7rgc7IsuDeGj--

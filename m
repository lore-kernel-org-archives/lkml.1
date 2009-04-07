Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZDGNAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZDGNAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZDGNAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:00:06 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48866 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZDGNAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:00:05 -0400
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239108689.15015.3.camel@maxim-laptop> (sfid-20090407_145137_740898_8D0C40FD)
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FXUH2CrM6OWQI2KTx2n2"
Date: Tue, 07 Apr 2009 14:56:41 +0200
Message-Id: <1239109001.22453.40.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FXUH2CrM6OWQI2KTx2n2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 15:51 +0300, Maxim Levitsky wrote:

> > > I noticed that always first attempt at scan fails when NM asks for sc=
an.
> > > I also noticed that this happens with quite recent kernels (I think
> > > 2,6.28) didn't have this behavior.
> >=20
> > I'm pretty sure it did.

> I am sure that on older kernel there was no -EBUSY error returned to
> userspace. It probably just stalled the client.

Can't imagine it did, maybe it just dropped the request though without
indicating an error.

> > > Looking a bit deeper I discovered that each time NM disconnects from =
a
> > > networks it sets random ssid/essid to the card (using wireless
> > > extensions)
> >=20
> > This forces a scan
> >=20
> > > After that scan fails for some time.
> > >=20
> > > as a NM free example you can run=20
> > >=20
> > > iwconfig wlan0 essid dummy
> > > iwlist scan
> >=20
> > and then this fails with EBUSY.
> Thanks for explanation.
> Since NM has its reasons to clear essid (to prevent unwanted
> association), then what can be  done to prevent this (and still use
> wireless extensions, since nl80211 support isn't yet mature)?

Nothing. Wext sucks, news at 11, yadda.

johannes

--=-FXUH2CrM6OWQI2KTx2n2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ202HAAoJEKVg1VMiehFYa1wP/2N4Qs2BTqNir8AoSn4OA01U
HuoW4JzCTvOB5H3fawtYBoKaCQQCoo3fHvsakZh8qJsdYdopKb4uRyl89l264JFY
1ckkUGNxrZevt+oKMYAVyy4xasQU+JxG2zx6T3RtBKCyNH3S3s3aouQUW2ghDvCL
M7LqeJia+ZgSM26DcVMRzgKAi2W0I0LfuA+4DBt5ElN+0K8R1IFoAJ4y42u8qcr3
Dpc2QU/ytH0G3uE/KM57BuBIIkuc66L0InAxfof5HwddhLOuapeXceP7MY3+xdFL
x+9vAQjNB5fcch0qYGOAYVJcjXCkjKXr3jXEMlIKY97gDletmlWwT1hcerFNJTRK
VfaNuMCqpPAYcSvQbIUqeZxy4z+127Fv0mZhCmSrsujs2XOby5U4CWzmPfQaNlV5
tU/FZWOHk3dQANLPnrdkzLiS2a8ktmvJiLMeyhTSRqY9tXhkOEF9su2rTVkvxSOA
+Jg2tVAAJUSztIcWRDgXWJCDa1B+UG5uIe84AGPVTmxdCUvDoEe09E1n2r4mVr9p
5zkneU5aXJwRDXHuMuqf4zkvRfMZj+QQVcu5qaD8QyanzZ/aTaLy0lTki2GYD6CG
L0FgyOwmsQO5u1Wlu07vvmMtDOVMIUXDSyWg9/RTU6AQlFE6lPSYo9sidQ8h3sBK
jQSv2CLTotcmWrxE2c9A
=co6y
-----END PGP SIGNATURE-----

--=-FXUH2CrM6OWQI2KTx2n2--


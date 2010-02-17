Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab0BQGTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 01:19:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38062 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0BQGTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 01:19:33 -0500
Date: Wed, 17 Feb 2010 17:19:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: build warning after final merge (sound tree)
Message-Id: <20100217171923.ea505d0f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Feb_2010_17_19_23_+1100_yDY3PLy66PHADwas"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Feb_2010_17_19_23_+1100_yDY3PLy66PHADwas
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

After merging, today's linux-next build (powerpc allyesconfig) produced
this warning:

sound/soc/soc-core.c: In function 'pmdown_time_set':
sound/soc/soc-core.c:149: warning: passing argument 3 of 'strict_strtol' fr=
om incompatible pointer type
include/linux/kernel.h:178: note: expected 'long int *' but argument is of =
type 'int *'

Introduced by commit dbe21408b15f04da4f80fb89a27b7cb067d6103e ("ASoC:
Make pmdown_time runtime configurable").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Feb_2010_17_19_23_+1100_yDY3PLy66PHADwas
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt7imsACgkQjjKRsyhoI8wQFQCgm5aG6FgCgJs6SSE0gz9GDhTM
ot0AniZXlDsAOPWsr+Tc/+MtGbMeZz2p
=PmF/
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Feb_2010_17_19_23_+1100_yDY3PLy66PHADwas--

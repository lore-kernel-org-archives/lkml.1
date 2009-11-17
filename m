Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZKQEx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZKQEx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 23:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZKQEx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 23:53:58 -0500
Received: from 71-20-254-182.war.clearwire-wmx.net ([71.20.254.182]:55634 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZKQEx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 23:53:58 -0500
Subject: Re: [BUG] intel KMS bug on i915
From: Eric Anholt <eric@anholt.net>
To: Mathieu Taillefumier <mathieu.taillefumier@free.fr>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4AFAA396.5040903@free.fr>
References: <4AFAA396.5040903@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Wnb7eFM/854RNMmiLQPz"
Date: Mon, 16 Nov 2009 20:54:21 -0800
Message-Id: <1258433661.4882.5.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Wnb7eFM/854RNMmiLQPz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-11 at 12:44 +0100, Mathieu Taillefumier wrote:
> Hello,
>=20
> I recently switched to the last git kernel (the rc6) and have a serious=20
> problem with KMS and xorg. I reported it to the xorg list but after some=20
> research it seems that this problem is caused by some recent change in=20
> the intel KMS stack. Some warnings and errors are reported by the=20
> kernel. they are the following (only a small part of it):
>=20
> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> render error detected, EIR: 0x00000000
> i915: Waking up sleeping processes
> [drm:i915_wait_request] *ERROR* i915_wait_request returns -5 (awaiting 2=20
> at 1)
> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> render error detected, EIR: 0x00000000
>=20
> This problem is recurrent with all 2.6.32-rc versions and gives rise to=20
> an unusable xorg (independent of the version), while the same xorg stack=20
> works pretty well with the 2.6.31 kernel. The hardware is a sony laptop=20
> with a intel 965 chipset and the bug can be reproduced at 100%

Could you bisect the problem?  I don't think I've seen reports of this
(fails at a time other than resume)

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-Wnb7eFM/854RNMmiLQPz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAksCLHwACgkQHUdvYGzw6vf7dACggjzJRg04UGM1jFaBvxYSXiTU
FXEAniTHSuAEsy4qvqleDECgWdi3mirj
=VLCQ
-----END PGP SIGNATURE-----

--=-Wnb7eFM/854RNMmiLQPz--


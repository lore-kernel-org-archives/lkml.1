Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbYHUNty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbYHUNty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYHUNto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:49:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46482 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbYHUNtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:49:43 -0400
Date: Thu, 21 Aug 2008 23:49:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, davem@davemloft.net
Subject: Re: [PATCH] math-emu: Fix compiler warnings
Message-Id: <20080821234935.33de917e.sfr@canb.auug.org.au>
In-Reply-To: <1219323021-7273-1-git-send-email-galak@kernel.crashing.org>
References: <1219323021-7273-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Aug_2008_23_49_35_+1000_oVgyvhHdt3dMfydk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Aug_2008_23_49_35_+1000_oVgyvhHdt3dMfydk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kumar,

On Thu, 21 Aug 2008 07:50:20 -0500 Kumar Gala <galak@kernel.crashing.org> w=
rote:
>
> Fix warnings of the form:
> arch/powerpc/math-emu/fsubs.c:15: warning: 'R_f1' may be used uninitializ=
ed in this function
> arch/powerpc/math-emu/fsubs.c:15: warning: 'R_f0' may be used uninitializ=
ed in this function
>=20
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
>=20
> I intend these patches to go via the powerpc.git tree if no one has issue=
s.
>=20
> - k
>=20
>  include/math-emu/op-2.h |    2 +-

Are you modifying the right file here?  There is also
arch/powerpc/math-emu/op-2.h which contains the same construct.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_Aug_2008_23_49_35_+1000_oVgyvhHdt3dMfydk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkitcm8ACgkQjjKRsyhoI8y5IACgnNw4T0S5wpOPBdfFoRi6ns/P
iosAnjxE1tXJ99ADfsi+ySaYpGOOVpNx
=aTmr
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Aug_2008_23_49_35_+1000_oVgyvhHdt3dMfydk--

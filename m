Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbZHMRJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbZHMRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbZHMRJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:09:25 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56316 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755156AbZHMRJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:09:25 -0400
X-Sasl-enc: z9y/jVpwdjfxKQK9iCZT3I0bCxyI6VPLdAnbfaYrKHV9 1250183365
Message-ID: <4A8448B7.6030007@imap.cc>
Date: Thu, 13 Aug 2009 19:09:11 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig Q: expressing a modularity dependency
References: <49E5E8D0.1090505@imap.cc>
In-Reply-To: <49E5E8D0.1090505@imap.cc>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigECC0149F520D7322B387B635"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigECC0149F520D7322B387B635
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

/me wrote, four months ago:
> My current attempts to port the Gigaset driver from isdn4linux
> to CAPI require the following Kconfig dependency:
>=20
> - If isdn4linux or kernelcapi or both are built as a module
>   (CONFIG_ISDN_I4L=3Dm || CONFIG_ISDN_CAPI=3Dm)
>   then gigaset can only be built as a module
>   (CONFIG_ISDN_DRV_GIGASET depends on m).
>=20
> - If neither isdn4linux nor kernelcapi ar built as a module
>   (CONFIG_ISDN_I4L!=3Dm && CONFIG_ISDN_CAPI!=3Dm),
>   including the case that neither is being built at all
>   (CONFIG_ISDN_I4L=3Dn && CONFIG_ISDN_CAPI=3Dn),
>   then gigaset may be built statically or as a module
>   (all three tristate settings for CONFIG_ISDN_DRV_GIGASET are
>   legal).
>=20
> How is that best expressed in Kconfig?

Judging from the complete silence following that question, the
answer is, apparently: not at all.

So I'll just put a notice in the help text then, warning people
not to set CONFIG_ISDN_DRV_GIGASET=3Dy if their ISDN subsystem
is built as a module. If anybody has a better idea I'll be
glad to hear it.

Thx
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigECC0149F520D7322B387B635
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKhEjDQ3+did9BuFsRAjQaAJ0RpamfGjh+7MdN4meJU/2NWsd0gQCePpZl
2z9qElEdZ1s7sj67yKamk74=
=l84U
-----END PGP SIGNATURE-----

--------------enigECC0149F520D7322B387B635--

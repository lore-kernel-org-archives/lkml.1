Return-Path: <linux-kernel-owner+w=401wt.eu-S934037AbXHJO05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037AbXHJO05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbXHJO0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:26:46 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:47007 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbXHJO0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:26:45 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Linux 2.6.22.2
Date: Fri, 10 Aug 2007 16:26:21 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, aabdulla@nvidia.com
References: <20070809214716.GA31414@kroah.com> <20070809214745.GA31425@kroah.com>
In-Reply-To: <20070809214745.GA31425@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1495117.7V9ypDGmmh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708101626.21927.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1495117.7V9ypDGmmh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I just noticed that PHY_OUI_VITESSE =3D=3D PHY_OUI_REALTEK. Is that really=
=20
intentional?

> diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
> index 42ba1c0..a361dba 100644
> --- a/drivers/net/forcedeth.c
> +++ b/drivers/net/forcedeth.c
> @@ -550,6 +550,8 @@ union ring_type {
>  /* PHY defines */
>  #define PHY_OUI_MARVELL	0x5043
>  #define PHY_OUI_CICADA	0x03f1
> +#define PHY_OUI_VITESSE	0x01c1
> +#define PHY_OUI_REALTEK	0x01c1
=2D=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1495117.7V9ypDGmmh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGvHWNxU2n/+9+t5gRAu/oAKD1Yhes+ZspYF1P1u0yYWvU2TOA7QCeKBwG
zrcNLgX115FG6c9qKzFrduk=
=rgtg
-----END PGP SIGNATURE-----

--nextPart1495117.7V9ypDGmmh--

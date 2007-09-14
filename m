Return-Path: <linux-kernel-owner+w=401wt.eu-S1764882AbXINN25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764882AbXINN25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 09:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbXINN2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 09:28:50 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:34994 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458AbXINN2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 09:28:49 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: Jon Ivar Rykkelid <jonry@pvv.org>
Subject: Re: sata_nv issues with MCP51 SATA controller
Date: Fri, 14 Sep 2007 15:29:07 +0200
User-Agent: KMail/1.9.7
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
References: <46E8EABF.3060409@pvv.org> <46E953D7.5070305@gmail.com> <46E97AFF.30202@pvv.org>
In-Reply-To: <46E97AFF.30202@pvv.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1658547.2tIuQWeGrt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709141529.11363.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1658547.2tIuQWeGrt
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Thursday 13 September 2007 Jon Ivar Rykkelid hast written:
> Resending, as my first attempts contained HTML and was blocked...
>
> Tejun Heo wrote:
> > Jon Ivar Rykkelid wrote:
> >> Thanks for the suggestion, but sata_nv is not built modular in my
> >> current kernel, so "no can do" at the moment
> >> (However, if some expert REALLY thinks this will fix things, I will
> >> CERTAINLY recompile and give it a go)
> >
> > Passing "sata_nv.adma=3D0" as kernel boot parameter will do the trick.
>
> Ahh, silly me... Of course!
> Ooops, I just got back, and verified: I actually have sata_nv running as
> a module after all on this server... My bad.
> I fixed /etc/modprobe.conf to include the following two lines:
> "
> alias scsi_hostadapter sata_nv
> options sata_nv adma=3D0
> ...
> "

I don't think it will matter, as adma doesn't affect MCP51, but only nforce=
4.=20
So I'd look for other trouble makers.
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1658547.2tIuQWeGrt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iD8DBQBG6oynxU2n/+9+t5gRAukJAKCNxvn/4cfQjVkuRart5d/rkMkoIgCg5JJi
o9WEHjw7RekP0371Un6ev5o=
=d7es
-----END PGP SIGNATURE-----

--nextPart1658547.2tIuQWeGrt--

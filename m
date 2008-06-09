Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbYFINcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbYFINcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbYFINcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:32:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51309 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYFINcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:32:08 -0400
Date: Mon, 9 Jun 2008 23:32:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/4] drivers/macintosh/smu.c: add missing of_node_put
Message-Id: <20080609233201.fc638cc7.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0806091521390.16009@ask.diku.dk>
References: <Pine.LNX.4.64.0806091420080.16009@ask.diku.dk>
	<20080609230752.f3bba16d.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0806091521390.16009@ask.diku.dk>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Jun_2008_23_32_01_+1000_Y8+KERnE/P1TbrA4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jun_2008_23_32_01_+1000_Y8+KERnE/P1TbrA4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Julia,

On Mon, 9 Jun 2008 15:22:53 +0200 (CEST) Julia Lawall <julia@diku.dk> wrote:
>
> > However, the error handling in that routine (smu_init) needs much more
> > work.
>=20
> Indeed, the smu =3D NULL at the end of the function seems a bit brutal - =
a=20
> lot of allocated data ends up not getting freed.  I can try to do=20
> something about it.  Did you see something else?

There are paths to fail: where you would need to of_node_put smu->db_node or
smu->msg_node (or both) and undo the smu->db_buf ioremap.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Jun_2008_23_32_01_+1000_Y8+KERnE/P1TbrA4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhNMNEACgkQTgG2atn1QN/gXgCeJZUty5Mov1oSItRv5dVnuAkk
ujAAn2DsIAVH3gRScVMm4Ilk/13E8Iwx
=sPVg
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jun_2008_23_32_01_+1000_Y8+KERnE/P1TbrA4--

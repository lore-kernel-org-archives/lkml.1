Return-Path: <linux-kernel-owner+w=401wt.eu-S1751473AbZI1EHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbZI1EHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 00:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbZI1EHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 00:07:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56853 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZI1EHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 00:07:51 -0400
Date: Mon, 28 Sep 2009 14:07:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       James Smart <James.Smart@Emulex.Com>
Subject: Re: linux-next: scsi tree boot filure
Message-Id: <20090928140744.df394b1f.sfr@canb.auug.org.au>
In-Reply-To: <20090927164314.9377c24c.sfr@canb.auug.org.au>
References: <20090927164314.9377c24c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Sep_2009_14_07_44_+1000_t5d=lxyHuCrlLfeC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Sep_2009_14_07_44_+1000_t5d=lxyHuCrlLfeC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Sun, 27 Sep 2009 16:43:14 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> I have bisected this down to commit
> 4acd10521ee002137b5d6791e234d7110033c782 ("[SCSI] scsi_lib_dma.c : fix
> bug /w dma maps on virtual vc ports") which was added between
> next-20090925 and next-20090926.
>=20
> Reverting that single commit from next-20090926 allows it to boot.

I have reverted this commit from linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Sep_2009_14_07_44_+1000_t5d=lxyHuCrlLfeC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrANpAACgkQjjKRsyhoI8yNyQCfaMdJQTerDopxwW4jqTN+pzo3
yrwAnin9N8eUmVAgfxdz286Gx2iO0ohU
=LDm7
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Sep_2009_14_07_44_+1000_t5d=lxyHuCrlLfeC--

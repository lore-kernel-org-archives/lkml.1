Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYAVXgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYAVXgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYAVXgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:36:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50184 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbYAVXgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:36:38 -0500
Date: Wed, 23 Jan 2008 10:36:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bryan Wu <bryan.wu@analog.com>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] procfs: constify function pointer tables
Message-Id: <20080123103616.591c234b.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
	<Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Jan_2008_10_36_16_+1100_e0y=C/i_A901dn_n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2008_10_36_16_+1100_e0y=C/i_A901dn_n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

On Tue, 22 Jan 2008 21:00:46 +0100 (CET) Jan Engelhardt <jengelh@computergm=
bh.de> wrote:
>
> -extern struct seq_operations mounts_op;
> +extern const struct seq_operations mounts_op;

[ and many others ... ]

I don't suppose you feel like finding appropriate header files to put
these declarations into?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Jan_2008_10_36_16_+1100_e0y=C/i_A901dn_n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHln36TgG2atn1QN8RAh2cAJ9IFGZP9N4qngBpnalysnOf4sCjIACgktyk
nwtPc/WmmILLWovmy1j5JsY=
=fUbW
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2008_10_36_16_+1100_e0y=C/i_A901dn_n--

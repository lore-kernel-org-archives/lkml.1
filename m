Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZFZCBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZFZCBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 22:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZFZCBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 22:01:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40999 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbZFZCBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 22:01:13 -0400
Date: Fri, 26 Jun 2009 12:01:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Dike <jdike@addtoit.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Boaz Harrosh <bharrosh@panasas.com>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
Message-Id: <20090626120111.ef8622ba.sfr@canb.auug.org.au>
In-Reply-To: <20090625145155.GA6383@c2.user-mode-linux.org>
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com>
	<4A3F4448.30502@panasas.com>
	<20090622085735.GB6499@cr0.nay.redhat.com>
	<20090622205226.fee30ba8.sfr@canb.auug.org.au>
	<20090625104901.GG6374@cr0.nay.redhat.com>
	<20090625145155.GA6383@c2.user-mode-linux.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Jun_2009_12_01_11_+1000_YNeEzb3njtCdI8sg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Jun_2009_12_01_11_+1000_YNeEzb3njtCdI8sg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Jun 2009 10:51:55 -0400 Jeff Dike <jdike@addtoit.com> wrote:
>
> On Thu, Jun 25, 2009 at 06:49:01PM +0800, Amerigo Wang wrote:
> > make ARCH=3Dum SUBARCH=3Dppc? Or something similar...
>=20
> It would need to be
> 	make ARCH=3Dum=20
> with an x86 cross-compiler.

On out PowerPC host I am using

	make ARCH=3Dum SUBARCH=3Di386 CROSS_COMPILE=3D<path to i386 cross compiler>

I am just building defconfig, would another config also be useful?

Currently plain "make ARCH=3Dum" on PowerPC doesn't appear to work.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Jun_2009_12_01_11_+1000_YNeEzb3njtCdI8sg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpEK+cACgkQjjKRsyhoI8wSkwCgkjJ4mO9aS59K8scR2ibpLv9S
cRIAn0TGIPSRwn6YkvVzBvWb4a50HEId
=CcyU
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Jun_2009_12_01_11_+1000_YNeEzb3njtCdI8sg--

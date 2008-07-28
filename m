Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbYG1AXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbYG1AXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 20:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbYG1AXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 20:23:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51894 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333AbYG1AXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 20:23:46 -0400
Date: Mon, 28 Jul 2008 10:23:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sean MacLennan <smaclennan@pikatech.com>
Cc: "Karsten Keil" <kkeil@suse.de>, "ppc-dev" <linuxppc-dev@ozlabs.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus" <torvalds@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] isdn: mISDN HFC PCI support depends on virt_to_bus()
Message-Id: <20080728102338.14d1c66e.sfr@canb.auug.org.au>
In-Reply-To: <20080727133918.72cbb127@lappy.seanm.ca>
References: <20080728023732.090aff83.sfr@canb.auug.org.au>
	<20080727133918.72cbb127@lappy.seanm.ca>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Jul_2008_10_23_38_+1000_IH10mwTz9sOA4CBZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Jul_2008_10_23_38_+1000_IH10mwTz9sOA4CBZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sean,

On Sun, 27 Jul 2008 13:39:18 -0400 Sean MacLennan <smaclennan@pikatech.com>=
 wrote:
>
> On Mon, 28 Jul 2008 02:37:32 +1000
> "Stephen Rothwell" <sfr@canb.auug.org.au> wrote:
>=20
> > On powerpc (allyesconfig build) we get this error:
> >=20
> > drivers/isdn/hardware/mISDN/hfcpci.c:1991: error: implicit
> > declaration of function 'virt_to_bus'
>=20
> When did mISDN make it into the kernel? And which kernel tree is it in?
> I don't see it in the Linux next tree....

Its not in linux-next (will be today).  It went straight into Linus' tree
late last week.

> I am very interested since we are trying to get mISDN working on the
> Warp. There was no notice that they got 2.6.26 compiling.

It won't even build on powerpc64, powercp32 should at least build.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Jul_2008_10_23_38_+1000_IH10mwTz9sOA4CBZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiNEYoACgkQjjKRsyhoI8xtfwCgsaSiR9wMPR49ErCVExoXj6ic
1mAAn1k/a4SI8UXlbREKZd+2tkQNWaAa
=5rO6
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Jul_2008_10_23_38_+1000_IH10mwTz9sOA4CBZ--

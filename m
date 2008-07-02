Return-Path: <linux-kernel-owner+w=401wt.eu-S1762266AbYGBELM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762266AbYGBELM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 00:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYGBEKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 00:10:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57321 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbYGBEKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 00:10:54 -0400
Date: Wed, 2 Jul 2008 14:10:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joseph Fannin <jfannin@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: inux-next 0701 mv643xx_eth powerpc build failure
Message-Id: <20080702141043.93cb35cf.sfr@canb.auug.org.au>
In-Reply-To: <20080702031111.GA26752@nineveh.local>
References: <20080702011434.6fb403d5.sfr@canb.auug.org.au>
	<20080702031111.GA26752@nineveh.local>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Jul_2008_14_10_43_+1000_Vl3/W8sujLEOsGie"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Jul_2008_14_10_43_+1000_Vl3/W8sujLEOsGie
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joseph,

On Tue, 1 Jul 2008 23:11:12 -0400 Joseph Fannin <jfannin@gmail.com> wrote:
>
> On Wed, Jul 02, 2008 at 01:14:34AM +1000, Stephen Rothwell wrote:
>=20
> [next-20080701]
>=20
> I'm getting a build failure on 32bit powerpc in -next, but not in mainlin=
e:
>=20
> drivers/net/mv643xx_eth.c: In function 'mv643xx_eth_netpoll':
> drivers/net/mv643xx_eth.c:2115: error: 'INT_CAUSE_EXT' undeclared
> (first use in this function)
> drivers/net/mv643xx_eth.c:2115: error: (Each undeclared identifier is
> reported only once
> drivers/net/mv643xx_eth.c:2115: error: for each function it appears in.)

Caused by commit 073a345c04b01da0cc5b79ac7be0c7c8b1691ef5 ("mv643xx_eth:
clarify irq masking and unmasking") from the net or wireless tree.  It
entered linux-next on June 19.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Jul_2008_14_10_43_+1000_Vl3/W8sujLEOsGie
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhq/8MACgkQjjKRsyhoI8xklACfShlKUyYr6SiW5EMAjEyDPoik
XqQAoJPU+C8XumFNmodKl7/pGuBS89VW
=G5SK
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Jul_2008_14_10_43_+1000_Vl3/W8sujLEOsGie--

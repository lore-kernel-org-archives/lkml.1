Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbYCADRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbYCADRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 22:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbYCADRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 22:17:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59141 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYCADRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 22:17:44 -0500
Date: Sat, 1 Mar 2008 14:17:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] firewire: fw-ohci: shut up false compiler warning
 on PPC32
Message-Id: <20080301141741.172013ba.sfr@canb.auug.org.au>
In-Reply-To: <tkrat.ee238048a5a50184@s5r6.in-berlin.de>
References: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de>
	<tkrat.ee238048a5a50184@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__1_Mar_2008_14_17_41_+1100_o/GMhk9mU8xKS2eN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__1_Mar_2008_14_17_41_+1100_o/GMhk9mU8xKS2eN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 1 Mar 2008 02:50:44 +0100 (CET) Stefan Richter <stefanr@s5r6.in-ber=
lin.de> wrote:
>
> Shut up two "may be used uninitialised in this function" warnings due to
> PPC32's implementation of dma_alloc_coherent().
>=20
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>=20
> Wasn't there a macro somewhere for this?

Yes, uninitialized_var() in linux/compiler*.h

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__1_Mar_2008_14_17_41_+1100_o/GMhk9mU8xKS2eN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHyMrYTgG2atn1QN8RAuGnAJoCyrWtO5Jhedr4l88lJ17mjeGoCwCfV41U
PoDIU5XhAEeKWD9B/bRMCao=
=ZoQs
-----END PGP SIGNATURE-----

--Signature=_Sat__1_Mar_2008_14_17_41_+1100_o/GMhk9mU8xKS2eN--

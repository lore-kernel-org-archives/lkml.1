Return-Path: <linux-kernel-owner+w=401wt.eu-S934437AbXGUK0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934437AbXGUK0u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 06:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933252AbXGUK0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 06:26:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56176 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933738AbXGUK0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 06:26:33 -0400
Date: Sat, 21 Jul 2007 20:26:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_VIRT_TO_BUS: what about bus_to_virt?
Message-Id: <20070721202637.8895b426.sfr@canb.auug.org.au>
In-Reply-To: <46A1D752.6070101@s5r6.in-berlin.de>
References: <46A1D752.6070101@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__21_Jul_2007_20_26_37_+1000_qaPSPBrLxNsCE=6+"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__21_Jul_2007_20_26_37_+1000_qaPSPBrLxNsCE=6+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jul 2007 11:52:18 +0200 Stefan Richter <stefanr@s5r6.in-berlin.d=
e> wrote:
>
> Is it sensible and safe to let a driver which uses bus_to_virt (but not
> virt_to_bus) depend on CONFIG_VIRT_TO_BUS?

If a driver depends on either bus_to_virt or virt_to_bus, then it
depend on CONFIG_VIRT_TO_BUS.  The intention is to exclude the driver from
being built on achitectures that don't implement those primitives (and
architectures always implement them both or neither).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__21_Jul_2007_20_26_37_+1000_qaPSPBrLxNsCE=6+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGod9iTgG2atn1QN8RAtnrAJ4ySU91+CekPaK8MHUKnP82K3WDHgCghHmm
8LMa7ahliRfXhna+HC3KhEU=
=8E8m
-----END PGP SIGNATURE-----

--Signature=_Sat__21_Jul_2007_20_26_37_+1000_qaPSPBrLxNsCE=6+--

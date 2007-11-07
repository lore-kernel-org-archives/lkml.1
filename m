Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbXKGD0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbXKGD0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbXKGD0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:26:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53372 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514AbXKGD0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:26:11 -0500
Date: Wed, 7 Nov 2007 14:26:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: David <david@unsolicited.net>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-rc1 - Regularly getting processes stuck in D state on
 startup
Message-Id: <20071107142609.071532ad.sfr@canb.auug.org.au>
In-Reply-To: <20071107141717.6eb0dc25.sfr@canb.auug.org.au>
References: <472F5F8B.7090200@unsolicited.net>
	<E1IpJLy-0002ag-TL@localhost>
	<394337271.18157@ustc.edu.cn>
	<20071107141717.6eb0dc25.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Nov_2007_14_26_09_+1100_sVvKtj1E3c7COj6h"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Nov_2007_14_26_09_+1100_sVvKtj1E3c7COj6h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Nov 2007 14:17:17 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Tue, Nov 06, 2007 at 04:00:06PM +0800, Fengguang Wu wrote:
> >=20
> > Could you try with the attached 4 patches? Two of them are expected to
> > fix your problem, another two are debugging ones(in case the problem
> > persists).
>=20
> Applying these four patches fixes it for me.  Obviously the reiserfs patch
> was not relevant in  my case (only using ext3).

I am now running on a kernel with just the
mm-speed-up-writeback-ramp-up-on-clean-systems.patch applied and I am
seeing no hangs.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Nov_2007_14_26_09_+1100_sVvKtj1E3c7COj6h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHMTBVTgG2atn1QN8RAmvDAKCAwigl7/YV7BTYXqOqI+aU5Mxo8QCfSiEC
AJPG6hslpEsyotS/vYfY8Zs=
=o9Iy
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Nov_2007_14_26_09_+1100_sVvKtj1E3c7COj6h--

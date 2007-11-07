Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbXKGDRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbXKGDRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbXKGDRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:17:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53870 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbXKGDRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:17:20 -0500
Date: Wed, 7 Nov 2007 14:17:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: David <david@unsolicited.net>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-rc1 - Regularly getting processes stuck in D state on
 startup
Message-Id: <20071107141717.6eb0dc25.sfr@canb.auug.org.au>
In-Reply-To: <394337271.18157@ustc.edu.cn>
References: <472F5F8B.7090200@unsolicited.net>
	<E1IpJLy-0002ag-TL@localhost>
	<394337271.18157@ustc.edu.cn>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Nov_2007_14_17_17_+1100_cd3VFckq_koP_sdC"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Nov_2007_14_17_17_+1100_cd3VFckq_koP_sdC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 06, 2007 at 04:00:06PM +0800, Fengguang Wu wrote:
>=20
> Could you try with the attached 4 patches? Two of them are expected to
> fix your problem, another two are debugging ones(in case the problem
> persists).

Applying these four patches fixes it for me.  Obviously the reiserfs patch =
was not relevant in  my case (only using ext3).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Nov_2007_14_17_17_+1100_cd3VFckq_koP_sdC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHMS5BTgG2atn1QN8RAuILAJ40AbDXGWfKwlyRJElk1N6lsQnDwACeP9MG
mahlfBm+a0UKtugKF8a0hoY=
=64OE
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Nov_2007_14_17_17_+1100_cd3VFckq_koP_sdC--

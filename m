Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbXJ3TvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbXJ3TvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbXJ3TvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:51:17 -0400
Received: from rhineheart.priorweb.be ([213.193.229.215]:53484 "HELO
	rhineheart.priorweb.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755635AbXJ3TvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:51:16 -0400
Date: Tue, 30 Oct 2007 20:50:55 +0100
From: Kristof Provost <Kristof@provost-engineering.be>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] several returns before unlocking in lmc_ioctl
Message-ID: <20071030195055.GJ32270@berith>
References: <471D4763.60604@tiscali.nl> <471D52C4.1050701@tiscali.nl> <20071030182832.GI32270@berith> <472782C0.4000807@tiscali.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLVHuoLXiP9kZBkt"
Content-Disposition: inline
In-Reply-To: <472782C0.4000807@tiscali.nl>
X-PGP-Fingerprint: 6B6E 5EED 8ECF FAE7 1F61  7458 5046 7D0E 11B0 0EE8
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam-Scanned: 2.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--yLVHuoLXiP9kZBkt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2007-10-30 20:15:12 (+0100), Roel Kluin <12o3l@tiscali.nl> wrote:
> Kristof Provost wrote:
> > I think you have an extra curly brace there. It breaks compile on my
> > system.
>=20
> You are right. thanks for notifying me and sorry for the trouble.
> please revert my patch (b463d40cdc436a12799a60a1d6ff1941a70a5bb6)
>=20
> and try instead:
This seems to compile just fine. I'm afraid I can't test it though. I
don't actually have that hardware. I mistakingly left it turned on, so I
noticed the compile error.

Kristof


--yLVHuoLXiP9kZBkt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHJ4sfUEZ9DhGwDugRAmF2AKCQXAdZOPmR9+hD3KqmhrI3niWfwgCcDiUV
TDlYT+m7hPZndyziW9WHSyw=
=NIp3
-----END PGP SIGNATURE-----

--yLVHuoLXiP9kZBkt--

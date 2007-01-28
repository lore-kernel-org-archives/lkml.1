Return-Path: <linux-kernel-owner+w=401wt.eu-S932923AbXA1WYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbXA1WYB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932925AbXA1WYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:24:01 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:42645 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932923AbXA1WYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:24:00 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch] use __u32 rather than u32 in userspace ioctls in usbdevice_fs.h
Date: Sun, 28 Jan 2007 17:24:39 -0500
User-Agent: KMail/1.9.5
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200701280723.57741.vapier@gentoo.org> <20070128094252.bc19261a.randy.dunlap@oracle.com>
In-Reply-To: <20070128094252.bc19261a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2036048.XFcjSQ1KpJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200701281724.40585.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2036048.XFcjSQ1KpJ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 28 January 2007 12:42, Randy Dunlap wrote:
> Have you now audited all ioctls (and sent patches) for this misbehavior?

my audit involved grepping the headers for '\<[us](8|16|32|64)\>' and sendi=
ng=20
patches for the headers that came up

ive sent patches for all except for asm-parisc/statfs.h ... but i'll do tha=
t=20
shortly once i finish pulling the parisc git tree
=2Dmike

--nextPart2036048.XFcjSQ1KpJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iQIVAwUARb0iqEFjO5/oN/WBAQL2XBAAqA/jYqlrxtPG31Byh4rgRFKWEMXgm1F6
5j6eTxmQXuWzZCQDCGl0imE29lXP3sHMOlaGsps05aSZE4swX6N8Pu2p6l1rovds
YJwdvCqf/fmULSkxrzVGzMuH5NIvOpiSduJtsBLKDBLMI/uIQc0bPtbHOoMBn02a
FfDGWLhcNDewnl0i6ZyORosyC6cBFOQV9rLNuwfVOXo4pTIdRMLR9JzMT88e9jgR
Q+kEDrgMb9fm+Bv805E0t3StIay/CJwdu/GRJzH/PAYcCXZhN91BcE34nKfo08Nq
ulObE1VC8z4Z6zt5xBKCbYIIPQ1jhyfSR0kAXOv3fJElEWdQ0kWg/96iiDKVZf2Z
AHDqeGLu7fVtKKMwar2J2i86+r3IwU+Lb1q7dsMxixIcRWNiscXbJpIgIkW6zNwf
dkyx6f4vaQfifnzHyVqectonigcNgTu47c/ULQPgF7bMHxeg+CSX5gREtT0KczE8
3O4X8sgPNHi1N7DX2ZMpeRMpmBlpUni3gATe21MGZvVlQ+gEX3UXKwztH4WXtUos
qLJFCb9NJXHNkcF51DVn3kFkEmTvOAb1KJiRXRvf1s/n+V0zpU8tFv2CteaMcM1/
GSn8WLQvMhztqZ3TSX+JtLZyzi7ILBUZUPs019uibE/VdJAVZHYSGZRy7ZYgGfp5
mzmdfcUouFE=
=T5yC
-----END PGP SIGNATURE-----

--nextPart2036048.XFcjSQ1KpJ--

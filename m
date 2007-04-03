Return-Path: <linux-kernel-owner+w=401wt.eu-S966206AbXDCRiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966206AbXDCRiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966201AbXDCRiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:38:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966206AbXDCRiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:38:05 -0400
Message-ID: <461290ED.2030303@redhat.com>
Date: Tue, 03 Apr 2007 10:37:49 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <Pine.LNX.4.61.0704031427210.32278@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0704031427210.32278@chaos.analogic.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig89840F58A2CEAF04415D3802"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig89840F58A2CEAF04415D3802
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

linux-os (Dick Johnson) wrote:
> Shouldn't it just be another system call? 223 is currently unused. You
> could fill that up with __NR_nr_cpus. The value already exists in
> the kernel.

You forget about Linus' credo "there shall be no sysconf-like syscall".
 I'd be all for sys_sysconf or even the limited sys_nr_cpus although
ideally then we'd have two syscalls (probed CPUs, active CPUs, in which
case sys_sysconf is the better choice).

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig89840F58A2CEAF04415D3802
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEpDt2ijCOnn/RHQRAiKqAJ4saOeXPJw54hW5TwjXRVQf8sJv3gCgp67M
rZuUoXisRxGbRWp/7H/NQTA=
=MEbD
-----END PGP SIGNATURE-----

--------------enig89840F58A2CEAF04415D3802--

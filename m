Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753273AbYLQOMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbYLQOMm (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 09:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYLQOMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 09:12:31 -0500
Received: from postman.teamix.net ([194.150.191.120]:37231 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751086AbYLQOMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 09:12:31 -0500
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: linux-kernel@vger.kernel.org
Subject: Re: physical memory limit of 64-bit linux
Date: Wed, 17 Dec 2008 15:12:15 +0100
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ingo Molnar <mingo@elte.hu>
References: <200812161556.25518.ms@teamix.de> <200812161654.17291.rjw@sisk.pl> <20081216164443.GY25779@one.firstfloor.org>
In-Reply-To: <20081216164443.GY25779@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4191591.oda1QXyAGh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812171512.24993.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4191591.oda1QXyAGh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Thanks to all for the answers and the detailed discussions.

Am Dienstag, 16. Dezember 2008 schrieb Andi Kleen:
> On Tue, Dec 16, 2008 at 04:54:16PM +0100, Rafael J. Wysocki wrote:
> > On Tuesday, 16 of December 2008, Martin Steigerwald wrote:
> > > Hi!
> > >
> > > What is the physical memory limit for 64-bit Linux? I read about 40 b=
it
> > > address bus for AMD Athlon X2 (1 TB) and 48 bit for Barcelona X4 (256
> > > TB).
> > >
> > > Is 64-bit linux able to use that amount - provided that one would
> > > manage to build it into a machine? Or does it have a lower limit?
>
> It depends on which 64bit Linux; e.g. IA64 has larger limits.

Is it 50 bits (1024 TB)?

ms@mango:~/lokal/Kernel/linux-2.6.27/arch/ia64>=20
egrep -r "(define.*MAX_PHYS_MEMORY|define.*MAX_PHYS_BITS|
define.*IA64_MAX_PHYSBITS)" *
include/asm/pgtable.h:#define IA64_MAX_PHYS_BITS        50      /* max. num=
ber=20
of physical address bits (architected) */
include/asm/pgtable.h:#define _PAGE_PPN_MASK            (((__IA64_UL(1) <<=
=20
IA64_MAX_PHYS_BITS) - 1) & ~0xfffUL)
sn/kernel/setup.c:#define MAX_PHYS_MEMORY               (1UL <<=20
IA64_MAX_PHYS_BITS)     /* Max physical address supported */

Ciao,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart4191591.oda1QXyAGh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklJCMAACgkQHhDFkwOZrpB1MwCcDSehkVDRvhy3UTCOU7GeiT+b
rToAn2eka6fDBEMGSC+LcoFF/yfqIvyi
=xYex
-----END PGP SIGNATURE-----

--nextPart4191591.oda1QXyAGh--

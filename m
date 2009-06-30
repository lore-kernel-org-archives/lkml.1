Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbZF3Bvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbZF3Bvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZF3Bvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:51:38 -0400
Received: from tamriel.snowman.net ([72.66.115.51]:53562 "EHLO
	tamriel.snowman.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZF3Bvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:51:37 -0400
Date: Mon, 29 Jun 2009 21:51:40 -0400
From: Stephen Frost <sfrost@snowman.net>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: dann frazier <dannf@hp.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, David Altobelli <david.altobelli@hp.com>,
       nagananda.chumbalkar@hp.com
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090630015140.GV20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net> <20090628172052.GA13957@ldl.fc.hp.com> <20090628223258.GP20436@tamriel.snowman.net> <20090630011541.GL22480@ldl.fc.hp.com> <20090630011709.GT20436@tamriel.snowman.net> <86802c440906291847p302d47eau1d1cbd07be59c61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uMD30mxrM/iO8yI3"
Content-Disposition: inline
In-Reply-To: <86802c440906291847p302d47eau1d1cbd07be59c61@mail.gmail.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snowman.net
X-Operating-System: Linux/2.6.26-1-amd64 (x86_64)
X-Uptime: 21:49:59 up 18 days, 23:16, 22 users,  load average: 0.16, 0.08,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uMD30mxrM/iO8yI3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Yinghai Lu (yhlu.kernel@gmail.com) wrote:
> it seems storage cards are different.
>=20
> dann's is 42:01.0 the LSI
> your's is 42.02.0 the cciss?

Yeah, I have a P600 installed in this DL585.

lspci -v for the P600:

42:02.0 RAID bus controller: Hewlett-Packard Company Smart Array P600
        Subsystem: Hewlett-Packard Company 3 Gb/s SAS RAID
        Flags: bus master, 66MHz, medium devsel, latency 120, IRQ 11
        Memory at dfef0000 (64-bit, non-prefetchable) [size=3D8K]
        I/O ports at 3000 [size=3D256]
        Memory at dfe80000 (64-bit, non-prefetchable) [size=3D256K]
        [virtual] Expansion ROM at de000000 [disabled] [size=3D256K]
        Capabilities: <access denied>
        Kernel driver in use: cciss

Of course, it seems to work ok under 2.6.22..

	Thanks,
	=09
		Stephen

--uMD30mxrM/iO8yI3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpJb6wACgkQrzgMPqB3kiiIagCfR40x0EefAlLSMydZJkThl8l7
yL8An0tlZiNP2fOn6skzrXu7CUqcNYSf
=MfWz
-----END PGP SIGNATURE-----

--uMD30mxrM/iO8yI3--

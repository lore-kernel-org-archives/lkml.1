Return-Path: <linux-kernel-owner+w=401wt.eu-S1763047AbYBLOBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763047AbYBLOBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760110AbYBLOA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:00:57 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:4712 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759514AbYBLOA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:00:56 -0500
Date: Tue, 12 Feb 2008 15:00:13 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux-tiny@selenic.com, "H. Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Configure out doublefault exception handler (Linux
 Tiny)
Message-ID: <20080212150013.57cb954e@crazy>
In-Reply-To: <20080212130428.GA32757@uranus.ravnborg.org>
References: <20080212110825.35db27cb@crazy>
	<20080212130428.GA32757@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_=2kTISv0./j2TBknM.GcCN";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_=2kTISv0./j2TBknM.GcCN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Sam,

Le Tue, 12 Feb 2008 14:04:28 +0100,
Sam Ravnborg <sam@ravnborg.org> a =C3=A9crit :

> We already have this in arch/x86/Kconfig.debug:

Oops, my usual "find . -name Kconfig" missed it. Thanks for pointing it
out!

> It may need a small update if this is valid for both 32 and 64 bit.

Doesn't seem so: there's only a doublefault_32.c, no doublefault_64.c.
However, I don't know the details of x86_64.

Thanks,

Thomas
--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/_=2kTISv0./j2TBknM.GcCN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsaZx9lPLMJjT96cRAkDPAJ4icVK1pUZi4BqZHeLNGq9kSE2PfwCaAsde
qbhMbRGXW2NGppZD8W77RYQ=
=DCsQ
-----END PGP SIGNATURE-----

--Sig_/_=2kTISv0./j2TBknM.GcCN--

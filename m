Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbXJOGhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbXJOGhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 02:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXJOGhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 02:37:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42069 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbXJOGhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 02:37:32 -0400
Date: Mon, 15 Oct 2007 16:37:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Olaf Hering <olaf@aepfle.de>, linux-kernel@vger.kernel.org
Subject: Re: apm system does not power off anymore
Message-Id: <20071015163720.09630ee4.sfr@canb.auug.org.au>
In-Reply-To: <20071014232316.4beb160f.akpm@linux-foundation.org>
References: <20071012125426.GA16626@aepfle.de>
	<20071014232316.4beb160f.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Oct_2007_16_37_20_+1000_IBQ6XW/P0VFUwO0S"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Oct_2007_16_37_20_+1000_IBQ6XW/P0VFUwO0S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 14 Oct 2007 23:23:16 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> Also, it's bad that the operator has to provide some special boot command=
-line
> option to make the machine work properly.  Please consider this to be a
> bug.  Has it always needed apm=3Dpower-off?

It has always been that way because the behaviour of APM on SMP is not
defined.  We discovered early that it will work (at least for powering
off) for most SMP machines as long as the APM calls are done on CPU 0.
However on an SMP machine that does not cope, very bad things happen -
thus the operator has to explictly enable the power off behaviour on an
SMP box.  (On UP power off is enabled by default.)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Oct_2007_16_37_20_+1000_IBQ6XW/P0VFUwO0S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHEwqlTgG2atn1QN8RAhmfAJ9FuQ4LGfLUKmPLGkYk551eFDsoKQCeIs94
Sn9SKQdbWOopzCM27BJxwlU=
=epC5
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Oct_2007_16_37_20_+1000_IBQ6XW/P0VFUwO0S--

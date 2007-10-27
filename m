Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbXJ0FGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbXJ0FGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 01:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbXJ0FGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 01:06:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58741 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbXJ0FGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 01:06:07 -0400
Date: Sat, 27 Oct 2007 15:05:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.23-mm1 - regression- PowerPC link failure at
 arch/powerpc/kernel/head_64.o
Message-Id: <20071027150558.a4522c9c.sfr@canb.auug.org.au>
In-Reply-To: <471AF4DE.80705@linux.vnet.ibm.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<471465D8.9030100@linux.vnet.ibm.com>
	<20071016002850.4296827e.akpm@linux-foundation.org>
	<47146BD4.8000608@linux.vnet.ibm.com>
	<471AF4DE.80705@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__27_Oct_2007_15_05_58_+1000_DPXIokGeWIWOfsM+"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__27_Oct_2007_15_05_58_+1000_DPXIokGeWIWOfsM+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 21 Oct 2007 12:12:38 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> After the bisecting, i found that the patch git-net.patch is the cause fo=
r the link failure.

The actual cause is my patch to mark some things in head_64.S as
init_refok.  I have a test patch which I will tidy up and post soon.
However, even with that fixed, I am running into a linker bug which Alan
Modra is looking into.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__27_Oct_2007_15_05_58_+1000_DPXIokGeWIWOfsM+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHIsc8TgG2atn1QN8RAp42AJkBwhO1J71GXNRiD1egrK/K8LXcEwCgh2iz
MoM8YNzrYu6UBCHxkMObnm8=
=bmxt
-----END PGP SIGNATURE-----

--Signature=_Sat__27_Oct_2007_15_05_58_+1000_DPXIokGeWIWOfsM+--

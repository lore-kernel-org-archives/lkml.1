Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbYDIL1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbYDIL1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 07:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYDIL11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 07:27:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57997 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbYDIL11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 07:27:27 -0400
Date: Wed, 9 Apr 2008 21:27:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Jacek Luczak" <difrost.kernel@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: Tree for April 9
Message-Id: <20080409212719.7d834c13.sfr@canb.auug.org.au>
In-Reply-To: <20080409210936.ec8ea986.sfr@canb.auug.org.au>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au>
	<d711229d0804090400p1c92a158j381b86e207a6f38a@mail.gmail.com>
	<20080409210936.ec8ea986.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Apr_2008_21_27_19_+1000_BnM0QHKEpe=LhqGR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Apr_2008_21_27_19_+1000_BnM0QHKEpe=LhqGR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jacek,

On Wed, 9 Apr 2008 21:09:36 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Thanks for the report, can you please send us your .config, please?

Don't worry about it, I found the problem.

It seems that commit 883a9fc4e5d9b0701f15d4e5a23608f942104721 ("x86:
cleanup - rename VM_MASK to X86_VM_MASK") from the x86 tree seems to have
missed some places.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Apr_2008_21_27_19_+1000_BnM0QHKEpe=LhqGR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH/KgcTgG2atn1QN8RAjdTAJwLFqB/LXZH/Dqt6j5JdzTzXrSy8QCfbpxA
XZaDg+7OEldQjQQ1f1J4KgI=
=DqFw
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Apr_2008_21_27_19_+1000_BnM0QHKEpe=LhqGR--

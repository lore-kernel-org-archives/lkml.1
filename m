Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbXA0Vax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbXA0Vax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 16:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107AbXA0Vaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 16:30:52 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:42810 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932106AbXA0Vaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 16:30:52 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] KVM: 'asm' operand has impossible constraints
Date: Sat, 27 Jan 2007 23:28:27 +0200
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, kvm-devel@lists.sourceforge.net
References: <200701260140.47760.caglar@pardus.org.tr> <45BB15F1.6020600@qumranet.com>
In-Reply-To: <45BB15F1.6020600@qumranet.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1589010.rve24a4AKo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200701272328.31532.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1589010.rve24a4AKo
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

27 Oca 2007 Cts tarihinde, Avi Kivity =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=
=C4=B1:=20
> The patch looks correct, but I don't understand the gcc error message.
> Are we sure this isn't a gcc 4.2 bug?
>
> "g" appears to be equivalent to "rmi", if "i" is impossible, gcc is free
> to use "r" or "m", no?

Accorgind to GCC devs. its not a bug=20
(http://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D29808), on comment #5 the=20
problem described like;

"g" means "r"+"i" so the register allocator in the -O0 case is selecting "r=
"=20
while in the optimize case is selecting "i"

=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1589010.rve24a4AKo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBFu8P/y7E6i0LKo6YRAuIgAJ0QXWk9UJN77TxGoK+4psFzBBTj2QCgmr6/
+MEbU+VgTSvhmGSJxiq6JHw=
=pfL0
-----END PGP SIGNATURE-----

--nextPart1589010.rve24a4AKo--

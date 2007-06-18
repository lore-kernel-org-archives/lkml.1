Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbXFRFxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbXFRFxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 01:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbXFRFxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 01:53:05 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57524 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbXFRFxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 01:53:04 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] make hdrscheck.sh force __asm__ in exported headers
Date: Mon, 18 Jun 2007 01:53:10 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200706171854.24763.vapier@gentoo.org> <200706180117.46809.vapier@gentoo.org> <20070617223436.2125b1a4.akpm@linux-foundation.org>
In-Reply-To: <20070617223436.2125b1a4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5379649.bU6e0rFU6c";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706180153.10698.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5379649.bU6e0rFU6c
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 18 June 2007, Andrew Morton wrote:
> On Mon, 18 Jun 2007 01:17:46 -0400 Mike Frysinger <vapier@gentoo.org> wrote:
> > On Monday 18 June 2007, Andrew Morton wrote:
> > > On 17 Jun 2007 18:54:24 -0400 Mike Frysinger <vapier@gentoo.org> wrote:
> > > > This updates scripts/hdrschecks.sh by grepping for asm() constructs
> > > > and rejecting them in favor of __asm__() in exported headers.
> > >
> > > And does the kernel pass these checks?
> >
> > nope ... should i audit the arches before this gets merged ?
>
> Yes please.  I'd rather not break things in this fashion: it causes a storm
> of emails which I need to redirect to the appropriate maintainers who then
> take an arbitrarily long time to do anything.  Meanwhile lots of testers
> get impacted and this reduces the testing level of all the other thousands
> of patches in there.

makes sense, i'll post some stuff

> Also, your changelog sucks:
>
>   This updates scripts/hdrschecks.sh by grepping for asm() constructs and
>   rejecting them in favor of __asm__() in exported headers.
>
> well OK.  But for what reason?  We can see a lot of pain in this patch but
> no gain.  The changelog should tell us what the benefit is, so we can make
> informed tradeoff decisions.

sorry, i blame GNU changelog style ;)
-mike

--nextPart5379649.bU6e0rFU6c
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARnYdxkFjO5/oN/WBAQKaFRAAotk68E2bQVcwa/vGOZC5yPi1T0KJ3e/j
jInzGcEd5pAoVBzzbMHoMQtxZrn50Ik05RCt5pfZAlaQqGstGfD5U0zY960CUws2
rRujmptk+iuYJsQM9J5iJKfZTb7p/0Q7FHVczudBIF2OKF/r8u+kIPzx8Vql9BZl
OgUY9YNNwoud6diZInCGDyBeYPqPacQ2Q7gW0UFEHgNOpIP27ya7wNaxxj01ejbS
gTbEQorouRCNmveMl9ADlSObSYg+LFHRlBrcPo9bfkEaoAsK6eOTCY9c0duShgs2
4l3yrLDJvNhZ6dZAzaFx+nNvkwMW2eL5j+5wVgQvN8dh0FPrXUsPWyrGJeDcw3sc
iEbxNOozLsbCwlbZWxgjRg0KWIRE8PnbzKDEJJMzWAMekjLKoMWGXa2C/4fGtvCr
bCBwS/Cb5Mxlr4xJbccfbTDMu0XDCCitOcg1QQbRkrdqpnznUdyz+Fj03GNwy1Ie
fu44iC7WwjGUy1uCa4TpmozegUoH5+Kt/y1ZRiTbIKPEJYcXrnMX5kCytJiQlk/v
B9NSC52j7qi4t+RyEarYVAJdnelNMsx/MKhX8aH4HbMLXxtBWkIEMUpAYJznkcG+
kbr7Nm+tpmtz5sE/4pDRXRcB1CoPUKDB9IGO1ly3oEYonWxHUetQU8p7cI9j1nCN
Csq4N9Qcwv4=
=DfiH
-----END PGP SIGNATURE-----

--nextPart5379649.bU6e0rFU6c--

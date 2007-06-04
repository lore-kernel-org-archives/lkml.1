Return-Path: <linux-kernel-owner+w=401wt.eu-S1754989AbXFDMN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbXFDMN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXFDMNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:13:20 -0400
Received: from www.sf-tec.de ([62.27.20.187]:40594 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753540AbXFDMNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:13:19 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Fix roundup_pow_of_two(1)
Date: Mon, 4 Jun 2007 14:13:11 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
References: <200705172356.57620.eike-kernel@sf-tec.de> <20070604114900.GS5500@stusta.de>
In-Reply-To: <20070604114900.GS5500@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1384675.3ayNLpsYU8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706041413.20477.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1384675.3ayNLpsYU8
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Adrian Bunk wrote:
> On Thu, May 17, 2007 at 11:56:56PM +0200, Rolf Eike Beer wrote:
> > Fix roundup_pow_of_two(1)
> >
> > 1 is a power of two, therefore roundup_pow_of_two(1) should return 1. It
> > does in case the argument is a variable but in case it's a constant it
> > behaves wrong and returns 0. Probably nobody ever did it so this was
> > never noticed.
>
> I'm not getting the problem.
> 2^0 = 1

Yes. But it returned 0 (not 1 << 0).

Eike

--nextPart1384675.3ayNLpsYU8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGZAHgXKSJPmm5/E4RApOLAJ9Ei4vCfN3uZ118XpaVZGlzOQfUSQCeKnTr
sbVgUeGt+BR6keT6x2lOs/M=
=wBIZ
-----END PGP SIGNATURE-----

--nextPart1384675.3ayNLpsYU8--

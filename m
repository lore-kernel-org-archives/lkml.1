Return-Path: <linux-kernel-owner+w=401wt.eu-S1764147AbXJZQQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764147AbXJZQQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbXJZQQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:16:11 -0400
Received: from mx39.mail.ru ([194.67.23.35]:60994 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbXJZQQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:16:10 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.24-rc1 regression] suspend fails
Date: Fri, 26 Oct 2007 20:16:01 +0400
User-Agent: KMail/1.9.7
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <200710252147.22814.arvidjaar@mail.ru> <200710252244.50711.rjw@sisk.pl>
In-Reply-To: <200710252244.50711.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart15304514.GKZ33QxuK2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710262016.02237.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart15304514.GKZ33QxuK2
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 26 October 2007, Rafael J. Wysocki wrote:
> On Thursday, 25 October 2007 19:47, Andrey Borzenkov wrote:
> > I can no more suspend with 2.6.24-rc1. 2.6.23 is fine. Here is kernel
> > log; config attached
>
> Please try the patch from:
> http://marc.info/?l=linux-mm-commits&m=119318609013090&w=2
>

Yes, that fixed it.

--nextPart15304514.GKZ33QxuK2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHIhLCR6LMutpd94wRAoPFAKChcx7RhAW1GeLBa/VngBc5fokU5gCdFbNi
VE+dN25KIYwX8F1UofRTQ0Q=
=P3A2
-----END PGP SIGNATURE-----

--nextPart15304514.GKZ33QxuK2--

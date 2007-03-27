Return-Path: <linux-kernel-owner+w=401wt.eu-S1750717AbXC0IAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750717AbXC0IAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 04:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbXC0IAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 04:00:19 -0400
Received: from iggypop2.siwnet.net ([81.216.65.12]:58364 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbXC0IAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 04:00:17 -0400
From: Marcus Better <marcus@better.se>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [4/5] 2.6.21-rc5: known regressions
Date: Tue, 27 Mar 2007 10:00:02 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       =?iso-8859-1?q?Fr=E9d=E9ric_Riss?= <frederic.riss@gmail.com>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015949.GB16477@stusta.de>
In-Reply-To: <20070327015949.GB16477@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2095699.r7YZgHSTch";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703271000.05341.marcus@better.se>
X-DSPAM-Result: Spam
X-DSPAM-Processed: Tue Mar 27 10:00:14 2007
X-DSPAM-Confidence: 0.6941
X-DSPAM-Probability: 1.0000
X-DSPAM-Signature: 4608cf0e744011719712363
X-DSPAM-Factors: 15,
	Content-Transfer-Encoding*quoted+printable, 0.99000,
	Content-Transfer-Encoding*printable, 0.99000,
	Content-Transfer-Encoding*quoted, 0.99000,
	Received*(unknown, 0.94439,
	Date*10, 0.18815,
	From*Marcus Better <marcus@better.se>, 0.23173,
	Subject*Re, 0.67420,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix), 0.67386,
	Cc*vger.kernel.org>, 0.40000,
	In-Reply-To*<20070327015949.GB16477, 0.40000,
	Content-Type*micalg=pgp, 0.40000,
	Received*Tue, 0.40000,
	an, 0.40000,
	Received*2007+10, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2095699.r7YZgHSTch
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> Subject    : second suspend to disk in a row results in an oops  (MSI)
> References : http://lkml.org/lkml/2007/3/17/43
>              http://lkml.org/lkml/2007/3/22/150
>              http://lkml.org/lkml/2007/3/26/205
>              http://lkml.org/lkml/2007/3/26/76
> Submitter  : Thomas Meyer <thomas@m3y3r.de>
>              Fr=C3=A9d=C3=A9ric Riss <frederic.riss@gmail.com>
>              Marcus Better <marcus@better.se>
> Handled-By : Eric W. Biederman <ebiederm@xmission.com>
> Patch      : http://lkml.org/lkml/2007/3/24/136
> Status     : patch was suggested

=46or the sake of completeness, my bisection resulted in this:

392ee1e6dd901db6c4504617476f6442ed91f72d is first bad commit
commit 392ee1e6dd901db6c4504617476f6442ed91f72d
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Thu Mar 8 13:04:57 2007 -0700

    [PATCH] msi: Safer state caching.

Marcus

--nextPart2095699.r7YZgHSTch
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGCM8FXjXn6TzcAQkRAuiGAJ9YdlNCzMXtbSKdaP8kljA9LQWArQCfeG5B
V5C3dOV57uFiw6ueNsGc++0=
=y4Jv
-----END PGP SIGNATURE-----

--nextPart2095699.r7YZgHSTch--



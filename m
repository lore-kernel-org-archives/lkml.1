Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbXDQIRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbXDQIRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbXDQIRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:17:25 -0400
Received: from iggypop2.siwnet.net ([81.216.65.12]:56267 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbXDQIRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:17:23 -0400
From: Marcus Better <marcus@better.se>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [3/3] 2.6.21-rc6: known regressions
Date: Tue, 17 Apr 2007 10:17:06 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Adrian Bunk <bunk@stusta.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704160823.39074.marcus@better.se> <1176705924.5129.1.camel@daplas>
In-Reply-To: <1176705924.5129.1.camel@daplas>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2229691.KJKIlgKNhY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704171017.07012.marcus@better.se>
X-DSPAM-Result: Spam
X-DSPAM-Processed: Tue Apr 17 10:17:17 2007
X-DSPAM-Confidence: 0.6106
X-DSPAM-Probability: 1.0000
X-DSPAM-Signature: 4624828d65371517314580
X-DSPAM-Factors: 15,
	Content-Transfer-Encoding*quoted+printable, 0.99000,
	Content-Transfer-Encoding*printable, 0.99000,
	Content-Transfer-Encoding*quoted, 0.99000,
	p+f, 0.99000,
	Received*(unknown, 0.94439,
	these, 0.14028,
	goes, 0.18583,
	Date*10, 0.18815,
	Yes, 0.20359,
	From*Marcus Better <marcus@better.se>, 0.24242,
	Subject*Re, 0.67420,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix), 0.67386,
	messages+Allocated, 0.40000,
	Allocated+buffer, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2229691.KJKIlgKNhY
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> Have you tried other combinations?
>
> s2ram -m -p -f
> s2ram -s -p -f

Yes, I tried these slightly different combinations:

s2ram -f -a3 -s: Works! The screen becomes green but is restored quickly. I=
t=20
prints the following messages:
Allocated buffer at 0x11000 (base is 0x0)
ES: 0x1100 EBX: 0x0000
Save video state failed
Calling restore_state_from
=46unction not supported?
Restore video state failed
Switching back to vt1

s2ram -f -a3 -p: Screen goes green and then blank. Everything hangs, doesn'=
t=20
react to keyboard input.

s2ram -f -a3 -m: Works!

(Tested with 2.6.21-rc7.)

Thanks,

Marcus

--nextPart2229691.KJKIlgKNhY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGJIKCXjXn6TzcAQkRAlH0AKD6Unv2+1+zuthQtx7n+WmIdnhQsACg+YzJ
3zsX5tHjG7rv5ZlzSUxPyMM=
=+y5Q
-----END PGP SIGNATURE-----

--nextPart2229691.KJKIlgKNhY--



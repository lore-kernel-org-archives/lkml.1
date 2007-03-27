Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbXC0JnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbXC0JnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 05:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbXC0JnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 05:43:08 -0400
Received: from iggypop2.siwnet.net ([81.216.65.12]:54592 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbXC0JnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 05:43:06 -0400
From: Marcus Better <marcus@better.se>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Date: Tue, 27 Mar 2007 11:42:46 +0200
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, pavel@suse.cz,
       linux-pm@lists.osdl.org
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <200703261942.52126.marcus@better.se> <20070326184857.GD16477@stusta.de>
In-Reply-To: <20070326184857.GD16477@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1384114.uKSMRjCNLc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703271142.50425.marcus@better.se>
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Mar 27 11:43:03 2007
X-DSPAM-Confidence: 0.6266
X-DSPAM-Probability: 0.0863
X-DSPAM-Signature: 4608e727744011284913811
X-DSPAM-Factors: 27,
	Received*(unknown, 0.94439,
	went, 0.15440,
	Received*11, 0.19184,
	Received*11, 0.19184,
	Yes, 0.20359,
	Yes, 0.20359,
	From*Marcus Better <marcus@better.se>, 0.22814,
	Date*46, 0.68663,
	Subject*Re, 0.67420,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix), 0.67386,
	Received*(Postfix), 0.67386,
	Cc*vger.kernel.org>, 0.40000,
	Subject*regressions+(v2), 0.40000,
	Cc*linux+pm, 0.40000,
	Cc*J., 0.40000,
	Content-Type*micalg=pgp, 0.40000,
	Received*Tue, 0.40000,
	Received*Tue, 0.40000,
	Cc*<rjw+sisk.pl>, 0.40000,
	from, 0.40000,
	Adrian+Bunk, 0.40000,
	Received*ESMTP, 0.40000,
	Received*ESMTP, 0.40000,
	Subject*[3/5], 0.40000,
	Content-Disposition*inline, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1384114.uKSMRjCNLc
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Adrian Bunk wrote:
> > > Does setting CONFIG_PCI_MSI=n make any difference?
> >
> > Yes, it does. The hanging resume problem went away.
>
> Thanks for testing.
>
> If you enable it again, does the patch from [1] also fix it?

Yes, it appears to fix it.

Marcus

--nextPart1384114.uKSMRjCNLc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGCOcaXjXn6TzcAQkRAut6AJ4gHdtuSC1CvXKPpsl53UWFGbY/GQCcDn0Q
oZPC7R94a1R7BAdUMGmI3jE=
=rGIL
-----END PGP SIGNATURE-----

--nextPart1384114.uKSMRjCNLc--



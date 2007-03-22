Return-Path: <linux-kernel-owner+w=401wt.eu-S1161021AbXCVLGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161021AbXCVLGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 07:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161029AbXCVLGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 07:06:06 -0400
Received: from iggypop2.siwnet.net ([81.216.65.12]:55379 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161021AbXCVLGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 07:06:04 -0400
X-Greylist: delayed 1857 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2007 07:06:04 EDT
From: Marcus Better <marcus@better.se>
To: tglx@linutronix.de
Subject: Re: [PATCH] clockevents: Fix suspend/resume to disk hangs
Date: Thu, 22 Mar 2007 11:34:47 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <eto9sh$262$1@sea.gmane.org> <1174485863.10840.80.camel@localhost.localdomain>
In-Reply-To: <1174485863.10840.80.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4684567.l8W3ERuXnE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703221134.52481.marcus@better.se>
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Mar 22 11:35:02 2007
X-DSPAM-Confidence: 0.5765
X-DSPAM-Probability: 0.0937
X-DSPAM-Signature: 46025bd620671587520628
X-DSPAM-Factors: 27,
	Received*(unknown, 0.94439,
	Received*11, 0.19184,
	Received*11, 0.19184,
	said, 0.19810,
	From*Marcus Better <marcus@better.se>, 0.23138,
	Subject*Re, 0.67420,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix)+with, 0.67386,
	Received*(Postfix), 0.67386,
	Received*(Postfix), 0.67386,
	Received*id+A44A231D, 0.40000,
	Content-Type*micalg=pgp, 0.40000,
	Cc*Adrian+Bunk, 0.40000,
	patch+[1], 0.40000,
	To*tglx, 0.40000,
	Received*ESMTP, 0.40000,
	Received*ESMTP, 0.40000,
	Content-Disposition*inline, 0.40000,
	Cc*stusta.de>, 0.40000,
	Date*2007+11, 0.40000,
	XFS+workqueue, 0.40000,
	From*Marcus, 0.40000,
	References*sea.gmane.org>, 0.40000,
	breakage, 0.40000,
	Content-Type*signature, 0.40000,
	[2]+Marcus, 0.40000,
	Received*(207.34.227.87.static.rny.siw.siwnet.net, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4684567.l8W3ERuXnE
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thomas Gleixner wrote:
> You said, that the breakage came between 2.6.20 and rc2. Can you bisect
> it ?

The XFS workqueue patch [1] fixes my problem [2].

Marcus

[1] http://permalink.gmane.org/gmane.linux.kernel/507616
[2] http://permalink.gmane.org/gmane.linux.kernel/505570

--nextPart4684567.l8W3ERuXnE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGAlvMXjXn6TzcAQkRAsj+AKCiArhnd3lgUyShEiBKRZ7kM22iRACglbKS
smYLELfAiLPQS5xK0qmfPts=
=fl+l
-----END PGP SIGNATURE-----

--nextPart4684567.l8W3ERuXnE--



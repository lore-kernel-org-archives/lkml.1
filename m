Return-Path: <linux-kernel-owner+w=401wt.eu-S933186AbXHPTHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbXHPTHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 15:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757814AbXHPTHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 15:07:23 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:52078 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758045AbXHPTHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 15:07:21 -0400
X-Greylist: delayed 1818 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2007 15:07:20 EDT
From: Michael Gerdau <mgerdau@tiscali.de>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.22.2-cfs-v19.1 stops honouring nice 3 after some hours
Date: Thu, 16 Aug 2007 20:36:53 +0200
User-Agent: KMail/1.9.7
Cc: Michael Gerdau <mgd@technosis.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200708151823.17623.mgd@technosis.de> <1187286737.6114.100.camel@twins>
In-Reply-To: <1187286737.6114.100.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1438384.NivTLNVYtX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708162037.07356.mgerdau@tiscali.de>
X-bounce-key: webpack.hosteurope.de;mgerdau@tiscali.de;1187291241;41c9d55b;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1438384.NivTLNVYtX
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> > I'm on 2.6.22.2-cfs-v19.1 -- I can't boot into 2.6.23-rc3 as part of
> > my daily work because my NVIDIA driver doesn't yet work with it though
> > I could try to do some X-less testing if need be.
>=20
> Please do try, a lot has changed since v19.1.
>=20
> FWIW the nv driver lets one do most desktop-ish things without problems,
> or so I've been told - just no 3d.

Damien Wyart was kind enough to point me to a patch that solved the compile
problem of the nv driver and I now have a ready-to-boot-into 2.6.23-rc3
lying around.

However due to other time constraints this will have to wait until tomorrow.

Anyway, observing the currently running CPU bound jobs and comparing their
progress (as documented by their logfiles) with the CPU % one of the jobs
receives (as documented by top -d 60) it seems as if this is not so much
a scheduling problem but an accounting issue.

=46WIW the jobs doing basically the same work are more or less head to head
after 12+ hours of computation while according to top one of them is
reported to receive roughly twice the CPU of the other.

I will retry with 2.6.23-rc3 tomorrow and over the weekend to see whether
the problem persists.

Best wishes,
Michael
=2D-=20
 Vote against SPAM - see http://www.politik-digital.de/spam/
 !tagline
 Michael Gerdau       email: mgerdau@tiscali.de
 GPG-keys available on request or at public keyserver

--nextPart1438384.NivTLNVYtX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGxJlTUYYhyuxDQc4RAqCVAJoCfQf42/pAm97T4dIgPc0Eg7NqqgCgjMa5
h5V/tUkhqFp1fau96Ofbcq0=
=koI2
-----END PGP SIGNATURE-----

--nextPart1438384.NivTLNVYtX--

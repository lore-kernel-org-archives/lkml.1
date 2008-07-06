Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbYGFFAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbYGFFAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 01:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYGFFAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 01:00:09 -0400
Received: from mx33.mail.ru ([194.67.23.194]:9558 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbYGFFAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 01:00:08 -0400
X-Greylist: delayed 78691 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jul 2008 01:00:08 EDT
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: All 2.6.26-rcX hang immediately after loading ohci_hcd
Date: Sun, 6 Jul 2008 08:59:54 +0400
User-Agent: KMail/1.9.9
Cc: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <200807051108.20183.arvidjaar@mail.ru> <200807051704.56141.david-b@pacbell.net> <alpine.LFD.1.10.0807051724090.3016@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807051724090.3016@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7552758.LXILxhFoQy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200807060859.58971.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7552758.LXILxhFoQy
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 06 July 2008, Linus Torvalds wrote:
>=20
> On Sat, 5 Jul 2008, David Brownell wrote:
> >=20
> > I seem to recall some oddness with RHSC on some platforms,
> > way back when I had lots of OHCI hardware and did comparative.
> > testing.  RHSC and RD did not act quite like the docs said ...
> >=20
> > Simple experiments:  add "distrust_firmware=3Dy" to the ohci

no change (it is possible that I screwed up something in a hurry)

> > module options.  Or:  try a kernel without CONFIG_PM enabled.
>=20
> I think Andrey said he was leaving for a week, so I don't think he'll be=
=20
> testing now.
>=20
> But Andrey - if you are on-line and have access to the machine, one thing=
=20
> to try would be to just do a=20
>=20
> 	git revert e872154921a6b5
>=20
> in case it really was that particular commit. It seems to revert cleanly=
=20
> (although I didn't actually check if the result then compiled/worked).
>=20

Looks much better; I am writing this now under 2.6.26-rc8 with above
commit reverted.

Any more tests will really have to wait till next weekend; sorry.

> And a "git bisect" would obviously be wonderful in case it wasn't.
>=20
> 			Linus
>=20
>=20



--nextPart7552758.LXILxhFoQy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhwUUwACgkQR6LMutpd94wdRgCgvn2Oigi9/Icg1rZGUzwCdUSr
ZtsAn0bPijCImGlVgNSXruw07GgXCbDg
=MVbE
-----END PGP SIGNATURE-----

--nextPart7552758.LXILxhFoQy--

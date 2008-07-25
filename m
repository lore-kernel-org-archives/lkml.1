Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbYGYReO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbYGYReO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 13:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYGYRd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 13:33:59 -0400
Received: from mail.uni-paderborn.de ([131.234.142.9]:39263 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYGYRd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 13:33:58 -0400
X-Greylist: delayed 1726 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2008 13:33:58 EDT
From: Nicolai =?iso-8859-1?q?H=E4hnle?= <prefect@upb.de>
To: dri-devel@lists.sourceforge.net
Subject: Re: X "Hangs" with RS690 + 2.6.26
Date: Fri, 25 Jul 2008 19:04:55 +0200
User-Agent: KMail/1.9.9
Cc: Jerome Glisse <glisse@freedesktop.org>,
       Jonathan McDowell <noodles@earth.li>, linux-kernel@vger.kernel.org
References: <20080725094334.GC30002@earth.li> <20080725121259.757499a9.glisse@freedesktop.org>
In-Reply-To: <20080725121259.757499a9.glisse@freedesktop.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1842095.2DVN5FiVKJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200807251905.04488.prefect@upb.de>
X-IMT-Spam-Score: 0.0 ()
X-PMX-Version: 5.4.2.338381, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2008.7.25.164600
X-IMT-Authenticated-Sender: uid=prefect,ou=People,o=upb,c=de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1842095.2DVN5FiVKJ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Freitag 25 Juli 2008 12:12:59 schrieb Jerome Glisse:
> This looks like usual engine lockup followed by CP lockup so
> that DMA buffer age never get written and we run out of DMA
> buffer thus freelist failing in infinite loop.
>
> I think we now know all the reason why we lockup, while a
> fix could be made for old ioctl we believe the best plan is
> to work on new ioctl with this fix in mind.

I can't help but feel uneasy with that kind of plan. After all, do "we"=20
*really* know what's going on? I always had the impression that we only kne=
w=20
things along the lines of "perhaps it's better to submit 3D stuff in indire=
ct=20
buffers".

If you *really* know what causes the lockups, could you please document tha=
t?=20
As in, what's the actual command processor sequence that is to blame? I kno=
w =20
that running e.g. a Nexuiz demo + glxgears window above it is apparently a=
=20
100% guaranteed lockup on my system (R420).

If you could share your progress in tracking down the sources of the lockup=
s,=20
I'd happily try to write a patch against the current system.

cu,
Nicolai

--nextPart1842095.2DVN5FiVKJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIigfA1iBctzupxNIRAqnIAJ92n7zxXjWHynd0wfBpCePHm9yjwQCgkjWn
TCEngGbygPDEOgpDVAdg01o=
=jWeE
-----END PGP SIGNATURE-----

--nextPart1842095.2DVN5FiVKJ--

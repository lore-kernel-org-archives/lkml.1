Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab0CEQMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:12:07 -0500
Received: from light.bluelinux.co.uk ([195.10.223.138]:38355 "EHLO
	light.bluelinux.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab0CEQMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:12:05 -0500
Date: Fri, 5 Mar 2010 18:11:43 +0200
From: Daniel Stone <daniel@fooishbar.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Ben Skeggs <skeggsb@gmail.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, dri-devel@lists.sf.net,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Making Xorg easier to test (was Re: [git pull] drm request 3)
Message-ID: <20100305161143.GG2505@tempa>
Mail-Followup-To: Daniel Stone <daniel@fooishbar.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Carlos R. Mafra" <crmafra2@gmail.com>,
	Ben Skeggs <skeggsb@gmail.com>, Dave Airlie <airlied@linux.ie>,
	linux-kernel@vger.kernel.org,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>, dri-devel@lists.sf.net,
	Ingo Molnar <mingo@elte.hu>
References: <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com> <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain> <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <20100305064955.GA6453@elte.hu> <84144f021003042306w2e017efbva2be364c1c4980a7@mail.gmail.com> <20100305074407.GC19703@elte.hu> <20100305100030.GA4970@Pilar.aei.mpg.de> <alpine.LFD.2.00.1003050726520.3788@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ChQOR20MqfxkMJg9"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003050726520.3788@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ChQOR20MqfxkMJg9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 05, 2010 at 07:53:46AM -0800, Linus Torvalds wrote:
> These days, there's a few dependencies you need to know about (I do agree=
=20
> that from a user perspective the thing might have been made a bit _too_=
=20
> modular)

Indeed, no argument here.

> That said, the _one_ thing I really wish could be done would be to make i=
t=20
> easier to install things side-by-side - and with the modularization, you=
=20
> really do want to do it module-by-module. One of the things that makes it=
=20
> so easy to test the kernel is that when you install one kernel, that=20
> doesn't affect the others, and you can go back-and-forth in testing.=20
> That's really important, because it makes testing trivial and non-scary=
=20
> even in the presense of issues that makes the new version unusable.

FWIW, Option "ModulePath" in xorg.conf lets you more or less do this;
the usual approach is to install your new server + drivers into a
separate prefix.

Cheers,
Daniel

--ChQOR20MqfxkMJg9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuRLT8ACgkQUVYB1rKAgJRjGACgprB69oDvr2dMobADjIFvITYd
vTAAmwYgwlRShsZIVjFzTHtswxHoRi2s
=wFlV
-----END PGP SIGNATURE-----

--ChQOR20MqfxkMJg9--

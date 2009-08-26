Return-Path: <linux-kernel-owner+w=401wt.eu-S932829AbZHZBv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbZHZBv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932631AbZHZBv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:51:28 -0400
Received: from mga05.intel.com ([192.55.52.89]:10480 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932564AbZHZBv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:51:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,276,1249282800"; 
   d="asc'?scan'208";a="487400852"
Date: Wed, 26 Aug 2009 09:51:27 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Eric Anholt <eric@anholt.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       mailing54 <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       Ma Ling <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: Linux 2.6.31-rc7
Message-ID: <20090826015127.GA1402@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Eric Anholt <eric@anholt.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	mailing54 <mailing54@plzk.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
	Ma Ling <ling.ma@intel.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Zhao, Yakui" <yakui.zhao@intel.com>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
 <4A941E8B.8080902@plzk.org>
 <alpine.LFD.2.01.0908251057260.3218@localhost.localdomain>
 <4A94599F.9020508@plzk.org>
 <alpine.LFD.2.01.0908251456530.3218@localhost.localdomain>
 <1251239637.26348.20.camel@gaiman.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <1251239637.26348.20.camel@gaiman.anholt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2009.08.25 15:33:57 -0700, Eric Anholt wrote:
> > However, the problem remains that KMS gets the output wrong, in ways th=
at=20
> > clearly X does not. Eric - it's clearly not just Mac Mini and my=20
> > experimental machine that have problems, but also a Macbook 2.1.
> >=20
> > I wonder why the Intel KMS logic doesn't look at which output was drive=
n=20
> > before it got invoked. Instead, it seems to want to try to detect=20
> > everything from scratch, even though we should be able to assume that i=
f=20
> > you boot from BIOS (or EFI, for that matter), the current state of the=
=20
> > graphics pipeline is likely meaningful.
>=20
> In my experience, the BIOS setup doesn't reflect what outputs should be
> used at runtime, and certainly not the correct configuration of the
> enabled outputs.  For example, if we went to this, the giant monitor
> attached to my laptop that I actually look at would go unused.
>=20

yeah, normally VBIOS startup just needs or only can driver one pipe, so
we don't have any pre knowledge except detect everything.

> > And clearly distros are trying to enable this. Which means that this is=
=20
> > getting way more important to solve.
>=20
> Yes, please open a bug on bugs.freedesktop.org and set severity=3Dcritical
> -- the people working on modesetting should pick it up and take a look
> at it.
>=20

we already have some mac relate bugs open, but please report on it so we
do have people with hardware to try and response. We have recently got a
MacBook, yakui is looking after the modesetting issue on it.

> For some of the DDC bugs, David M=FCller has an interesting-looking patch
> to parse the BIOS's tables describing what DDC pin is used for VGA on
> 852, though it looks like it should be usable on much more.  I was
> hoping the modesetting guys would review it and ack, but no response so
> far.
>=20

We should also have floating patch on that, hope we'll prepare and cleanup
the patches for mac soon.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqUlR8ACgkQsQQaM014GCffJgCfcgnfPENM0IkRpSXCfTVo+Bxn
FxUAnR1ZitnM0CtYgz+abtb5e0QPCP2u
=yd9F
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--

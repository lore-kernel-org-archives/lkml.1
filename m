Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZIKBuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZIKBuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZIKBuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:50:07 -0400
Received: from mga10.intel.com ([192.55.52.92]:4943 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751975AbZIKBuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:50:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,367,1249282800"; 
   d="asc'?scan'208";a="725910767"
Date: Fri, 11 Sep 2009 09:49:54 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, stern@rowland.harvard.edu
Subject: Re: [PATCH 1/3] agp/intel: remove restore in resume
Message-ID: <20090911014954.GB15773@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	stable@kernel.org, stern@rowland.harvard.edu
References: <1252028615-13785-1-git-send-email-zhenyuw@linux.intel.com>
 <20090910134252.5fc54ce2.akpm@linux-foundation.org>
 <20090911010342.GA6819@zhen-devel.sh.intel.com>
 <20090910182257.91c66541.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
In-Reply-To: <20090910182257.91c66541.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2009.09.10 18:22:57 -0700, Andrew Morton wrote:
>=20
> We still don't have a changelog for this patch which explains to the
> -stable maintainers (and those who follow -stable commits):
>=20
> a) what bug this patch fixes and
>=20
> b) why they should merge it - this should be ovbious if a) is provided.
>=20
> this isn't pointless paperwork - it matters to those who maintain and
> use the -stable tree.  Vague references to traffic on the linux-pm list
> aren't at all useful.

Yes, thanks. I'll try to make it clear the bug it fixes.=20

> >From my reading of the above, it appears that Alan was experiencing
> <secretbug> and this patch was tested and fixed it, yes?

secretbug? Alan found resume hang on his 845G machine during his pm test,
and root cause that to extra pci config restore in agp/intel resume functio=
n,
which was having a fix to workaround resume order problem for host bridge a=
nd
gfx device for pci restore. But now this is handled by early pci resume alr=
eady,
but the extra restore in resume caused machine hang. So remove them fixed
Alan's hang issue.

Sorry, I might misread on something, "early version merged" seems nonsense.
I'll try to send them again.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqprMIACgkQsQQaM014GCdCZwCgh+lL8qotvJm8Y5Dws20Ohbby
rz8AnR3tFZSl5Jg93buLME8csNh91kHV
=wA2O
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--

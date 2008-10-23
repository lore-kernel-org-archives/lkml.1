Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYJWVEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYJWVEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYJWVEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:04:36 -0400
Received: from home.keithp.com ([63.227.221.253]:32775 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbYJWVEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:04:35 -0400
Subject: Re: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
	2.6.27-rc1)
From: Keith Packard <keithp@keithp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: keithp@keithp.com, mingo@elte.hu, nickpiggin@yahoo.com.au,
       airlied@linux.ie, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       dri-devel@lists.sf.net, yinghai@kernel.org
In-Reply-To: <20081023133840.d4eef579.akpm@linux-foundation.org>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com>
	 <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu>
	 <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu>
	 <1224517744.5195.1.camel@koto.keithp.com> <20081022093615.GF12453@elte.hu>
	 <1224793332.22877.8.camel@koto.keithp.com>
	 <20081023133840.d4eef579.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5QQv7wLns3r65AR6OUOi"
Date: Thu, 23 Oct 2008 14:03:45 -0700
Message-Id: <1224795825.22877.21.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5QQv7wLns3r65AR6OUOi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 13:38 -0700, Andrew Morton wrote:

> I guess one could reimplemenet kmap_atomic_pfn() to call this.  Sometime.

The goal is to stop needing this function fairly soon and replace it
with a 'real' io-mapping implementation for 32-bit processors.

> Given that all highmem-implementing archtiectures must use the same
> declaration here, we might as well put it into include/linux/highmem.h.
> Although that goes against current mistakes^Wcode.

I'd hate to break with a long tradition.

> Does powerpc32 still implement highmem?  It seems that way.  You broke
> it, no?

Powerpc32 doesn't have kmap_atomic_pfn either. Seems like the set of
HIGHMEM functions is not uniform across architectures.

--=20
keith.packard@intel.com

--=-5QQv7wLns3r65AR6OUOi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJAOaxQp8BWwlsTdMRAjREAJ9MdT6Bkifq1xHD1MUMEd8jjliFXQCfeD6I
NqZsRqC52vWDS9BX6Q3Vgmc=
=05QY
-----END PGP SIGNATURE-----

--=-5QQv7wLns3r65AR6OUOi--


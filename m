Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYEJGaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYEJGaH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 02:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYEJG3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 02:29:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:57103 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYEJG3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 02:29:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,464,1204531200"; 
   d="asc'?scan'208";a="279931612"
Subject: Re: [git head] X86_PAT & mprotect
From: Keith Packard <keith.packard@intel.com>
Reply-To: keith.packard@intel.com
To: Dave Airlie <airlied@gmail.com>
Cc: keith.packard@intel.com,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       Frans Pop <elendil@planet.nl>, "Barnes, Jesse" <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <21d7e9970805092319n1d31be36h2f2c7d46622f46c8@mail.gmail.com>
References: <200805022122.03576.elendil@planet.nl>
	 <200805051932.41827.elendil@planet.nl>
	 <20080506224240.GA18706@linux-os.sc.intel.com>
	 <20080507070217.GD32195@elte.hu>
	 <Pine.LNX.4.64.0805071941140.18916@blonde.site>
	 <20080507232326.GB10757@linux-os.sc.intel.com>
	 <20080509100818.GD19617@elte.hu>
	 <20080509200519.GA10897@linux-os.sc.intel.com>
	 <21d7e9970805091511n2c6b6cfeu433b184d3031196d@mail.gmail.com>
	 <924EFEDD5F540B4284297C4DC59F3DEE010471B6@orsmsx423.amr.corp.intel.com>
	 <21d7e9970805092319n1d31be36h2f2c7d46622f46c8@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ydkwcGyZoYgQt5gzlLD6"
Organization: Intel Corp
Date: Fri, 09 May 2008 23:29:50 -0700
Message-Id: <1210400990.29406.179.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ydkwcGyZoYgQt5gzlLD6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-10 at 16:19 +1000, Dave Airlie wrote:

> Keithp, I hope we didn't error check the mremap return values :)

        /* KLUDGE ALERT -- rewrite the PTEs to turn off the CD and WT bits =
*/
        mprotect (map->memory, map->size, PROT_NONE);
        mprotect (map->memory, map->size, PROT_READ|PROT_WRITE);

No return value checks for us ;-)

--=20
keith.packard@intel.com

--=-ydkwcGyZoYgQt5gzlLD6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIJUDeQp8BWwlsTdMRAge6AJ4/o1HMrWVMEon1NCMr8c7p/c2BoACgp3Jp
QD5ki3NgyzVd3/Osq3a1V0g=
=RRbu
-----END PGP SIGNATURE-----

--=-ydkwcGyZoYgQt5gzlLD6--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYEJFqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYEJFqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 01:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYEJFqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 01:46:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:35434 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbYEJFqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 01:46:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,464,1204531200"; 
   d="asc'?scan'208";a="562949184"
Subject: Re: [git head] X86_PAT & mprotect
From: Keith Packard <keith.packard@intel.com>
Reply-To: keith.packard@intel.com
To: Dave Airlie <airlied@gmail.com>
Cc: keith.packard@intel.com, Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh@veritas.com>,
       Frans Pop <elendil@planet.nl>, Jesse Barnes <jesse.barnes@intel.com>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <21d7e9970805091511n2c6b6cfeu433b184d3031196d@mail.gmail.com>
References: <200805022122.03576.elendil@planet.nl>
	 <200805040910.57088.elendil@planet.nl>
	 <200805050857.57661.jesse.barnes@intel.com>
	 <200805051932.41827.elendil@planet.nl>
	 <20080506224240.GA18706@linux-os.sc.intel.com>
	 <20080507070217.GD32195@elte.hu>
	 <Pine.LNX.4.64.0805071941140.18916@blonde.site>
	 <20080507232326.GB10757@linux-os.sc.intel.com>
	 <20080509100818.GD19617@elte.hu>
	 <20080509200519.GA10897@linux-os.sc.intel.com>
	 <21d7e9970805091511n2c6b6cfeu433b184d3031196d@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-34NQL3VAyamaCvI8HLyb"
Organization: Intel Corp
Date: Fri, 09 May 2008 22:45:59 -0700
Message-Id: <1210398359.29406.169.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-34NQL3VAyamaCvI8HLyb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-10 at 08:11 +1000, Dave Airlie wrote:

> Wow this kinda puts X in a nasty position, we have 2.6.25 and previous ke=
rnels
> where we use the original /sys interfaces and nasty hack to
> workaround, but on 2.6.26 we magically need to
> switch to the /sys _uc interfaces or the users X will slow down.

It didn't sound like that to me -- using UC- should mean that if we set
up MTRRs correctly, we'll get WC access for our frame buffer. Did I miss
something here?

--=20
keith.packard@intel.com

--=-34NQL3VAyamaCvI8HLyb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIJTaXQp8BWwlsTdMRAg0XAJ9wi+Go2IsvnF+bDIojkgLhTj+EYQCfY1/G
eB9wRLJKdR4wN8JxbNxQtMw=
=sRzF
-----END PGP SIGNATURE-----

--=-34NQL3VAyamaCvI8HLyb--


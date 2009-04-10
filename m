Return-Path: <linux-kernel-owner+w=401wt.eu-S1765780AbZDJUmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765780AbZDJUmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759104AbZDJUlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:41:55 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:46076 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548AbZDJUly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:41:54 -0400
Subject: Re: [patch 0/6] x86, PAT, CPA: Cleanups and minor bug fixes
From: Eric Anholt <eric@anholt.net>
To: venkatesh.pallipadi@intel.com
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <20090409212646.511925000@intel.com>
References: <20090409212646.511925000@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gJocG84gRo03vZzHQj0A"
Date: Fri, 10 Apr 2009 13:41:52 -0700
Message-Id: <1239396112.6356.10.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gJocG84gRo03vZzHQj0A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-09 at 14:26 -0700, venkatesh.pallipadi@intel.com wrote:
> This patchset contains cleanups and minor bug fixes in x86 PAT and CPA
> related code. The bugs were mostly found by code inspection. There
> should not be any functionality changes with this patchset.

I've been curious, what are you using to test PAT changes for
regressions?  I've got some regression tests at:

http://cgit.freedesktop.org/xorg/app/intel-gpu-tools/

Requires KMS enabled and master of libdrm, but after that you can sudo
make check, and it tests execution of several DRM paths without
requiring X.  In benchmarks/ there are a few microbenchmarks of various
mapping types, which has been useful in making sure that we're ending up
with the right PTEs.

It should work on all Intel GPUs from the 830 through the GM45, though I
haven't tested pre-915 much.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-gJocG84gRo03vZzHQj0A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknfrw4ACgkQHUdvYGzw6vdhDACfTR6KW0PvsK10JKLy8oeVZLMH
awQAoItvO3DDBf+FKoXEJG5tTTAfOhQ6
=rwj7
-----END PGP SIGNATURE-----

--=-gJocG84gRo03vZzHQj0A--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1763614AbZDHHmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763614AbZDHHmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761938AbZDHHlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:41:47 -0400
Received: from ist.d-labs.de ([213.239.218.44]:46775 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbZDHHlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:41:46 -0400
Date: Wed, 8 Apr 2009 09:41:33 +0200
From: Florian Mickler <florian@mickler.org>
To: Eric Anholt <eric@anholt.net>
Cc: LKML <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       airlied@linux.ie, keithp@keithp.com
Subject: Re: Regression X Hangs at bootup -- PATCH
Message-ID: <20090408094133.094dae4d@schatten>
In-Reply-To: <1239158039.19045.6.camel@gaiman.anholt.net>
References: <20090406225541.0e1e043b@schatten>
	<1239069835.31656.109.camel@gaiman.anholt.net>
	<20090407092346.058d19a0@schatten>
	<1239121300.9617.0.camel@gaiman.anholt.net>
	<20090407221425.3dc1831e@schatten>
	<1239158039.19045.6.camel@gaiman.anholt.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/rZNdQUvz2Y=ucH7Uqsb8NO/";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rZNdQUvz2Y=ucH7Uqsb8NO/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 07 Apr 2009 19:33:59 -0700
Eric Anholt <eric@anholt.net> wrote:

> On Tue, 2009-04-07 at 22:14 +0200, Florian Mickler wrote:
> > On Tue, 07 Apr 2009 09:21:40 -0700
> > Eric Anholt <eric@anholt.net> wrote:
> >=20
> >=20
> > > drm_free's other arguments are unused memory debug leftovers.
> > > I've got a patch I need to push at airlied to remove
> > > drm_malloc/drm_calloc/drm_free.
> > >=20
> > in that case it is of course a non issue. but would you mind=20
> > to add a note like 'this adds a memleak to
> > i915_gem_put_relocs_to_user which will be fixed in a followup
> > patch', or just rebase it onto that patch?=20
>=20
> Just to be clear, there is no memleak:
>=20
> /** Wrapper around kfree() */
> static __inline__ void drm_free(void *pt, size_t size, int area)
> {
> 	kfree(pt);
> }
>=20
> The arg would only get used if DRM_DEBUG_MEMORY was set, but there's
> no way in the kernel to do so.  I don't think anybody's used it in
> years, and I'm sure there would be broken drm_free arguments since
> it's untested.  It was never very useful even back in the day, since
> most everything ended up lumped under DRM_MEM_DRIVER.
>=20

wtf? alright :)
thx for clarifying. i should have just looked.=20

bye,
Florian

--Sig_/rZNdQUvz2Y=ucH7Uqsb8NO/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkncVTIACgkQPjqCkyL3Kv2hEgCeP7/1vSVSD3b5iCYb1jdSAIbx
Ov0AoLW6KQtrqjXr89KSudEZe2U6hn4J
=4imc
-----END PGP SIGNATURE-----

--Sig_/rZNdQUvz2Y=ucH7Uqsb8NO/--

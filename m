Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbZC0Qg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbZC0Qg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbZC0Qgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:36:48 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:55102 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbZC0Qgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:36:48 -0400
Subject: Re: DRM lock ordering fix series
From: Eric Anholt <eric@anholt.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
In-Reply-To: <1238170767.8275.2397.camel@gaiman.anholt.net>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <87ocvnmhqx.fsf@basil.nowhere.org>
	 <1238170767.8275.2397.camel@gaiman.anholt.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PVJAhb5WtgAqpcHdGdrT"
Date: Fri, 27 Mar 2009 09:36:45 -0700
Message-Id: <1238171805.8275.2434.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PVJAhb5WtgAqpcHdGdrT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-27 at 09:19 -0700, Eric Anholt wrote:
> On Fri, 2009-03-27 at 10:34 +0100, Andi Kleen wrote:
> > Eric Anholt <eric@anholt.net> writes:
> >=20
> > > Here's hopefully the final attempt at the lock ordering fix for GEM. =
 The
> > > problem was introduced in .29 with the GTT mapping support.  We hashe=
d out
> > > a few potential fixes on the mailing list and at OSTS.  Peter's plan =
was
> > > to use get_user_pages, but it has significant CPU overhead (10% cost =
to text
> > > rendering, though part of that is due to some dumb userland code.  Bu=
t it's
> > > dumb userland code we're all running).
> >=20
> >=20
> > You are aware that there is a fast path now (get_user_pages_fast) which
> > is significantly faster? (but has some limitations)
>=20
> In the code I have, get_user_pages_fast is just a wrapper that calls the
> get_user_pages in the way that I'm calling it from the DRM.

Ah, I see: that's a weak stub, and there is a real implementation.  I
didn't know we could do weak stubs.

Still, needs docs badly.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-PVJAhb5WtgAqpcHdGdrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknNAJ0ACgkQHUdvYGzw6vcx3ACeOb4UI6kqLlSDLdHKBTwEFaOg
UqYAn0DJF/K8kNwq4I913rvV0lMv6w+9
=2O1O
-----END PGP SIGNATURE-----

--=-PVJAhb5WtgAqpcHdGdrT--


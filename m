Return-Path: <linux-kernel-owner+w=401wt.eu-S934447AbXGSHu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934447AbXGSHu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 03:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbXGSHuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 03:50:13 -0400
Received: from lisa.in-ulm.de ([217.10.8.8]:49775 "HELO mail.in-ulm.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757705AbXGSHuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 03:50:11 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 03:50:11 EDT
Date: Thu, 19 Jul 2007 09:39:48 +0200
From: Christian Ehrhardt <lk@c--e.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719073948.GI18840@lisa.in-ulm.de>
References: <Line.LNX.4.64.0707141233490.26711@d.namei> <20070718183503.541026f8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/8E7gjuj425jZz9t"
Content-Disposition: inline
In-Reply-To: <20070718183503.541026f8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/8E7gjuj425jZz9t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 18, 2007 at 06:35:03PM -0700, Andrew Morton wrote:
> On Sat, 14 Jul 2007 12:37:01 -0400 (EDT)
> James Morris <jmorris@namei.org> wrote:
>=20
> > Convert LSM into a static interface, as the ability to unload a security
> > module is not required by in-tree users and potentially complicates the
> > overall security architecture.
> >=20
> > Needlessly exported LSM symbols have been unexported, to help reduce API
> > abuse.
> >=20
> > Parameters for the capability and root_plug modules are now specified
> > at boot.
> >=20
> > The SECURITY_FRAMEWORK_VERSION macro has also been removed.
>=20
> I'd like to understand who is (or claims to be) adversely affected by this
> change, and what their complaints (if any) will be.

I am currently loading and unloading a prototype like security module
on a regular basis. The fact that such a module can be loaded and
unloaded (albeit in an unsecure way) greatly simplifies development.
Thus this change will adversely affect me and probably also others that
develop LSMs.

Additionally deployment of and choice among legitimate security modules
that may or may not (yet) be part of the main kernel tree is simplified by
an option to load these security modules (e.g. at boot time) into a running
kernel. This way a distribution can provide AppArmor, SELinux, SecLevl and
whatever as options very much in the same way that this works for a driver.

> Because I prefer my flamewars pre- rather than post-merge.

You asked for oppinion. I do not plan to engage in any flamewars.

    regards     Christian


--/8E7gjuj425jZz9t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGnxVEDWylJVHJF/wRAiXkAKC+DyKA0M9BbmatzNPy4vZc4MkVsgCguKlU
2nRuvSMVGwCbYo0GV5oslAk=
=yTjq
-----END PGP SIGNATURE-----

--/8E7gjuj425jZz9t--

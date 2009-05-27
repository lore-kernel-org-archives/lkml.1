Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbZE0VjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbZE0VjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbZE0VjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:39:04 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:36634 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbZE0VjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:39:02 -0400
Subject: Re: [PATCH] kbuild: generate modules.builtin
From: Scott James Remnant <scott@ubuntu.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <ac3eb2510905271426m7ef228aq2c86940ee8a727bb@mail.gmail.com>
References: <20090526152540.GA28341@sepie.suse.cz>
	 <ac3eb2510905271426m7ef228aq2c86940ee8a727bb@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-B2W1YLK0KHOXM7snRpRs"
Date: Wed, 27 May 2009 23:38:49 +0200
Message-Id: <1243460329.7913.1.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B2W1YLK0KHOXM7snRpRs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-27 at 23:26 +0200, Kay Sievers wrote:

> On Tue, May 26, 2009 at 17:25, Michal Marek <mmarek@suse.cz> wrote:
> > To make it easier for tools like mkinitrd to detect whether a needed
> > module is missing or whether it is compiled into the kernel, install a
> > modules.builtin file listing all modules built into the kernel. This is
> > done by generating an alternate config file with all tristate =3Dy opti=
ons
> > set to =3DY and reading the makefiles with this config included. The bu=
ilt
> > in modules then appear in obj-Y.
>=20
> That looks very useful.
>=20
> We like to have that for modprobe not to throw an error if a "module"
> is already in the kernel, because it is compiled in. Only modules with
> parameters show up in /sys/modules/ and they are already handled fine.
>=20
Agree, this helps us support both distro kernels with some built-ins and
modular kernels.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-B2W1YLK0KHOXM7snRpRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkodsukACgkQSnQiFMl4yK5loACfZRmDZ8lTtxSAZLL7iBxLEfGH
/hwAn1g6bkuv2+enlMkdRb938kY6env3
=hbwn
-----END PGP SIGNATURE-----

--=-B2W1YLK0KHOXM7snRpRs--


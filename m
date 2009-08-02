Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296AbZHBNuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbZHBNuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZHBNuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:50:07 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:41594 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZHBNuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:50:06 -0400
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when
 using pipes in core_pattern
From: Scott James Remnant <scott@ubuntu.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com
In-Reply-To: <20090802002217.GA3012@localhost.localdomain>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
	 <1248880382.23840.78.camel@quest>
	 <20090729201857.GC17410@hmsreliant.think-freely.org>
	 <1249071610.4800.5.camel@wing-commander>
	 <20090801134146.GA19910@localhost.localdomain>
	 <1249151332.6731.5.camel@wing-commander>
	 <20090802002217.GA3012@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-V7aHLfzx1RL61kv/cPoH"
Date: Sun, 02 Aug 2009 14:49:56 +0100
Message-Id: <1249220996.3638.0.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V7aHLfzx1RL61kv/cPoH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-08-01 at 20:22 -0400, Neil Horman wrote:

> On Sat, Aug 01, 2009 at 07:28:52PM +0100, Scott James Remnant wrote:
> > On Sat, 2009-08-01 at 09:41 -0400, Neil Horman wrote:
> >=20
> > > > > Not without additional work.  If init crashed in the initramfs, I=
 don't think
> > > > > theres a way to handle that.  If it crashes at some later time, I=
 think it just
> > > > > gets restarted IIRC.  I'm sure you can change that behavior, but =
this patch
> > > > > doesn't address that.
> > > > >=20
> > > > When the system init daemon crashes, the kernel PANICs.  When not u=
sing
> > > > core_pattern, this is ok, we get a core file - when using apport, a=
s far
> > > > as I can tell it never waits for apport to finish so we don't get t=
he
> > > > crash.
> > > >=20
> > > This is non-sensical.  If init crashes, and the kernel panics, you'll=
 only get a
> > > core by sheer luck and good fortune.
> > >=20
> > Or by being a bit clever.  Upstart catches the SIGSEGV and the signal
> > handler forks a child process, unmasking the signal in that child
> > process with no signal handler installed.
> >=20
> I don't see how this works.  How is upstart (which by definition is a chi=
ld of
> init (pid 1)) going to catch a SIGSEGV from its parent?  How would any pr=
ocess
> catch a signal targeted to its parent?
>=20
Upstart *is* /sbin/init (pid 1)

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-V7aHLfzx1RL61kv/cPoH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp1mX8ACgkQSnQiFMl4yK6dWwCfWdhSXD6xN4zcn1Hdkhtlk1Da
Ql8An0/RI98PFGVcgz5p13sssJutBAUL
=tErN
-----END PGP SIGNATURE-----

--=-V7aHLfzx1RL61kv/cPoH--


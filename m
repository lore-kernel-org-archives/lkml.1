Return-Path: <linux-kernel-owner+w=401wt.eu-S1764363AbXJZSWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764363AbXJZSWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbXJZSWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:22:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:34674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbXJZSWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:22:47 -0400
Date: Fri, 26 Oct 2007 11:23:53 -0700
From: John Johansen <jjohansen@suse.de>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: jjohansen@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 19/45] Add struct vfsmount parameters to vfs_rename()
Message-ID: <20071026182352.GA32415@suse.de>
References: <20071026064024.243943043@suse.de> <20071026064049.534093497@suse.de> <20071026073749.GE8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20071026073749.GE8181@ftp.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 26, 2007 at 08:37:49AM +0100, Al Viro wrote:
> On Thu, Oct 25, 2007 at 11:40:43PM -0700, jjohansen@suse.de wrote:
> > The vfsmount will be passed down to the LSM hook so that LSMs can compu=
te
> > pathnames.
>=20
> You know, you really are supposed to understand the code you are modifyin=
g...
> Quiz: what are those vfsmounts and how are they related?
>=20

In the current code, both vfsmounts are always identical, and so one of
the two should go, agreed.

The thought behind passing both vfsmounts was that they could differ but
point to the same super_block, in which case renames would still be
possible at least from a filesystem point of view. The essential
restriction here is that both files must be on the same device; the vfs
restriction of not allowing cross-mount renames is arbitrary.
Cross-mount renames are not allowed currently, and granted, they may not
be very useful, either.

> Al, carefully abstaining from saying what he really thinks of LSM and its
> users...

As always, it's a pleasure to see the genuine Viro charm at play.

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFHIjC4i/GH5xuqKCcRAiAiAJ4qEr53dgB+pjy30hImXevxg4NACQCeMZt6
PAkQ/Da3wQ0bH3S1vIurguI=
=/R2t
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--

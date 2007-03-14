Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbXCNSss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbXCNSss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932635AbXCNSsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:48:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601AbXCNSsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:48:46 -0400
Date: Wed, 14 Mar 2007 11:48:42 -0700
From: Seth Arnold <seth.arnold@suse.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] [Patch 1/1] IBAC Patch
Message-ID: <20070314184841.GJ27643@suse.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <1173394696.5981.12.camel@localhost.localdomain> <20070314022713.GI27643@suse.de> <1173871526.18147.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxgVX529wKDqfd1k"
Content-Disposition: inline
In-Reply-To: <1173871526.18147.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--mxgVX529wKDqfd1k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 14, 2007 at 07:25:26AM -0400, Mimi Zohar wrote:
> It's a little bit of both. :-) Initially it was written to help me with=
=20

:)

> implementing and testing the integrity provider.  But it could definitely=
 stand
> on it's own.  As Serge Hallyn commented http://lkml.org/lkml/2007/3/13/22=
0, by=20
> adding the mmap hook, IBAC could replace the LSM aspect of digsig and a g=
pg=20
> based integrity provider, could be written, instead of EVM, which is TPM =
based.

Thanks.

> > > +	if (status !=3D INTEGRITY_PASS) {	/* FAIL | NO_LABEL */
> > > +		if (!is_kernel_thread(current)) {
> >=20
> > Please remind me why kernel threads are exempt?
>=20
> You really don't want to prevent kernel threads from working. Nasty things
> happen.

But under what conditions would a kernel thread not pass integrity? I
guess if it doesn't have an associated dentry... or the dentry refers
to something else? (What does knfsd do -- it is started by a userland
program which causes the kernel to start up some tasks for NFS..)

> For integrity_measure(), EVM calls IMA, if enabled, to extend the
> measurement list with the hash value it provides. In most cases, EVM
> has already calculated the hash value, when it was called to verify the
> data. integrity_measure() is not meant to be intrusive, so it is defined
> as void.

Oh, ok, thanks.

> Thank you for your comments.

My pleasure, thanks for the quick responses.

--mxgVX529wKDqfd1k
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFF+EOJ+9nuM9mwoJkRAhcGAKCTtUCrs0djtIioKQ0U91KT6iWBrgCfcJil
3Z4jWNGmRUyEijFgYsrTe3M=
=b8S1
-----END PGP SIGNATURE-----

--mxgVX529wKDqfd1k--

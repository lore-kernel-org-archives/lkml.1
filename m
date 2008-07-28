Return-Path: <linux-kernel-owner+w=401wt.eu-S1761634AbYG1VYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634AbYG1VYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYG1VYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:24:04 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43144 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbYG1VYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:24:02 -0400
Date: Mon, 28 Jul 2008 14:23:54 -0700
From: Eric B Munson <ebmunson@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
Message-ID: <20080728212354.GB8450@us.ibm.com>
References: <cover.1216928613.git.ebmunson@us.ibm.com> <1217277204.23502.36.camel@nimitz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <1217277204.23502.36.camel@nimitz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Jul 2008, Dave Hansen wrote:

> On Mon, 2008-07-28 at 12:17 -0700, Eric Munson wrote:
> >=20
> > This patch stack introduces a personality flag that indicates the
> > kernel
> > should setup the stack as a hugetlbfs-backed region. A userspace
> > utility
> > may set this flag then exec a process whose stack is to be backed by
> > hugetlb pages.
>=20
> I didn't see it mentioned here, but these stacks are fixed-size, right?
> They can't actually grow and are fixed in size at exec() time, right?
>=20
> -- Dave

The stack VMA is a fixed size but the pages will be faulted in as needed.

--=20
Eric B Munson
IBM Linux Technology Center
ebmunson@us.ibm.com


--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIjjjqsnv9E83jkzoRAugvAKD36x3OyfiN/GtGM+x0LJ6SL7e7TgCdHOOf
OGGM1jiwgdCWkwRUj/Gd/Fg=
=5CJt
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--

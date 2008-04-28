Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbYD1Ey3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbYD1Ey3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 00:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYD1EyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 00:54:22 -0400
Received: from ozlabs.org ([203.10.76.45]:50801 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbYD1EyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 00:54:21 -0400
Subject: Re: [RFC Patch 1/1] debugfs_printk and debugfs_dump interface
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: prasad@linux.vnet.ibm.com
Cc: dwilder@us.ibm.com, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, hunt@redhat.com, dave@linux.vnet.ibm.com
In-Reply-To: <20080428044854.GA5437@in.ibm.com>
References: <20080415111459.GB5295@in.ibm.com>
	 <20080415112603.GA5770@in.ibm.com> <48066EBE.3040608@us.ibm.com>
	 <20080421124329.GA14118@in.ibm.com> <4810FA44.9060402@us.ibm.com>
	 <20080425074200.GA8600@in.ibm.com> <20080425081959.GA15011@in.ibm.com>
	 <1209343851.8118.1.camel@localhost>  <20080428044854.GA5437@in.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hPo3rLHX0+AO3fsPQKy0"
Date: Mon, 28 Apr 2008 14:54:20 +1000
Message-Id: <1209358460.8118.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hPo3rLHX0+AO3fsPQKy0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-04-28 at 10:18 +0530, K. Prasad wrote:
> On Mon, Apr 28, 2008 at 10:50:51AM +1000, Michael Ellerman wrote:
> > On Fri, 2008-04-25 at 13:49 +0530, K. Prasad wrote:
> > > On Fri, Apr 25, 2008 at 01:12:00PM +0530, K. Prasad wrote:
> > > > Please find the new patch below.
> > > > >=20
> > > Let the email slip through a little early. Please find the revised
> > > patch below.
> > >=20
> > > Thanks,
> > > K.Prasad
> > >=20
> > > This patch introduces two new interfaces called debugfs_printk and=20
> > > debugfs_dump which can be used to print to the debugfs mount directly=
.
> > > It uses the 'trace' infrastructure underneath and is a patch over it.
> > > A sample file is also created to demonstrate its ease of use.
> >=20
> > I still think debugfs_printk() is not the right name, as it is not part
> > of the existing family of debugfs_* routines.

> Whether to call it trace_printk() and trace_dump() is a suggestion I
> would like to ask David Wilder (and others). Let me know if you think
> there are better names.

That would be my pick, given that it's using the trace infrastructure
and it's defined in trace.h, implemented in trace.c, and documented in
trace.txt :)

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-hPo3rLHX0+AO3fsPQKy0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIFVh8dSjSd0sB4dIRAoPUAJ9a3mHjBk4tmbC8EqEfBBuIeSjyGgCgrmcH
fKPPSSwIFLF8endCYYnDJPg=
=t1F7
-----END PGP SIGNATURE-----

--=-hPo3rLHX0+AO3fsPQKy0--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1764771AbYD1AvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764771AbYD1AvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbYD1Auy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:50:54 -0400
Received: from ozlabs.org ([203.10.76.45]:53168 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbYD1Aux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:50:53 -0400
Subject: Re: [RFC Patch 1/1] debugfs_printk and debugfs_dump interface
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: prasad@linux.vnet.ibm.com
Cc: dwilder@us.ibm.com, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, hunt@redhat.com, dave@linux.vnet.ibm.com
In-Reply-To: <20080425081959.GA15011@in.ibm.com>
References: <20080415111459.GB5295@in.ibm.com>
	 <20080415112603.GA5770@in.ibm.com> <48066EBE.3040608@us.ibm.com>
	 <20080421124329.GA14118@in.ibm.com> <4810FA44.9060402@us.ibm.com>
	 <20080425074200.GA8600@in.ibm.com>  <20080425081959.GA15011@in.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/YkxUS44z/zQkBcTaYR1"
Date: Mon, 28 Apr 2008 10:50:51 +1000
Message-Id: <1209343851.8118.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/YkxUS44z/zQkBcTaYR1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-04-25 at 13:49 +0530, K. Prasad wrote:
> On Fri, Apr 25, 2008 at 01:12:00PM +0530, K. Prasad wrote:
> > Please find the new patch below.
> > >=20
> Let the email slip through a little early. Please find the revised
> patch below.
>=20
> Thanks,
> K.Prasad
>=20
> This patch introduces two new interfaces called debugfs_printk and=20
> debugfs_dump which can be used to print to the debugfs mount directly.
> It uses the 'trace' infrastructure underneath and is a patch over it.
> A sample file is also created to demonstrate its ease of use.

I still think debugfs_printk() is not the right name, as it is not part
of the existing family of debugfs_* routines.

>  Documentation/trace.txt        |   21 ++++
>  include/linux/trace.h          |   55 +++++++++++
>  lib/trace.c                    |  202 ++++++++++++++++++++++++++++++++++=
+++++--
>  samples/trace/Makefile         |    2=20
>  samples/trace/fork_new_trace.c |   97 +++++++++++++++++++

And it's not in debugfs.h

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-/YkxUS44z/zQkBcTaYR1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIFR9rdSjSd0sB4dIRAkBBAJ4sODMpCmunEnNgtGR2ss1D4SEckACgl/c0
GgNw0Zkv+vikKh4bhWOn40c=
=psX9
-----END PGP SIGNATURE-----

--=-/YkxUS44z/zQkBcTaYR1--


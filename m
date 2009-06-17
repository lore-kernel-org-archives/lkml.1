Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbZFQFrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbZFQFrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 01:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbZFQFrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 01:47:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41454 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbZFQFrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 01:47:12 -0400
Date: Wed, 17 Jun 2009 15:46:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: linux-next: ext4 tree build failure
Message-Id: <20090617154655.73343a5e.sfr@canb.auug.org.au>
In-Reply-To: <20090616221147.GC14788@mit.edu>
References: <20090616144413.50e975f9.sfr@canb.auug.org.au>
	<20090616203034.GB14788@mit.edu>
	<20090616221147.GC14788@mit.edu>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Jun_2009_15_46_55_+1000_v5cFV8uh8/Pjv4F9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Jun_2009_15_46_55_+1000_v5cFV8uh8/Pjv4F9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

On Tue, 16 Jun 2009 18:11:47 -0400 Theodore Tso <tytso@mit.edu> wrote:
>
> On Tue, Jun 16, 2009 at 04:30:34PM -0400, Theodore Tso wrote:
> > On Tue, Jun 16, 2009 at 02:44:13PM +1000, Stephen Rothwell wrote:
> > > Hi Ted,
> > >=20
> > > Today's linux-next build (powerpc ppc64_defconfig) failed like this a=
fter
> > > the slab tree was merged:
> > >=20
> > > In file included from fs/jbd2/checkpoint.c:26:
> > > include/trace/events/jbd2.h:11: error: expected ')' before '(' token
> > > include/trace/events/jbd2.h:31: error: expected ')' before '(' token
> >=20
> > Hmm... I wonder why the slab tree would be messing with tracing
> > include files.
> >=20
> > Which slab tree is it?  Is it Pekka's?
> >=20
> >       git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git
> >=20
>=20
> Never mind, I see the problem.   Thanks for pointing it out!

Because of this, I will use the ext4 tree that was in next-20090615
(which is actually empty relative to Linus tree) until you can come up
with a fix.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Jun_2009_15_46_55_+1000_v5cFV8uh8/Pjv4F9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko4g08ACgkQjjKRsyhoI8zYKwCgiQRtes3ggnw7Z7zzOLaDZe+C
n2IAoL33I3LmeSABQGH+sFkXfIh/Ob/j
=C4mv
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Jun_2009_15_46_55_+1000_v5cFV8uh8/Pjv4F9--

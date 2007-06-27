Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbXF0Go4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbXF0Go4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbXF0Gos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:44:48 -0400
Received: from ns.suse.de ([195.135.220.2]:38202 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbXF0Goq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:44:46 -0400
Date: Tue, 26 Jun 2007 23:43:53 -0700
From: John Johansen <jjohansen@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Message-ID: <20070627064353.GC14656@suse.de>
References: <20070626230756.519733902@suse.de> <20070626165202.bfe8e6df.akpm@linux-foundation.org> <20070627022403.GB14656@suse.de> <20070626194700.5b0ff477.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <20070626194700.5b0ff477.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 26, 2007 at 07:47:00PM -0700, Andrew Morton wrote:
> On Tue, 26 Jun 2007 19:24:03 -0700 John Johansen <jjohansen@suse.de> wrot=
e:
>=20
> > >=20
> > > so...  where do we stand with this?  Fundamental, irreconcilable
> > > differences over the use of pathname-based security?
> > >=20
> > There certainly seems to be some differences of opinion over the use
> > of pathname-based-security.
>=20
> I was refreshed to have not been cc'ed on a lkml thread for once.  I guess
> it couldn't last.
>=20
sorry about that

> Do you agree with the "irreconcilable" part?  I think I do.
>=20
I will concede that this may be the case for some.  However I am still
hopeful (perhaps naive) that this isn't the case in general.

> I suspect that we're at the stage of having to decide between
>=20
> a) set aside the technical issues and grudgingly merge this stuff as a
>    service to Suse and to their users (both of which entities are very
>    important to us) and leave it all as an object lesson in
>    how-not-to-develop-kernel-features.
>=20
>    Minimisation of the impact on the rest of the kernel is of course
>    very important here.
Agreed, and I hope any changes that are made are for the benefit
of the kernel in general and will find uses in other parts.

>=20
> versus
>=20
> b) leave it out and require that Suse wear the permanent cost and
>    quality impact of maintaining it out-of-tree.  It will still be an
>    object lesson in how-not-to-develop-kernel-features.
>=20
> Sigh.  Please don't put us in this position again.  Get stuff upstream
> before shipping it to customers, OK?  It ain't rocket science.
>=20
Indeed, I can only appologize for the past, and offer reassurances
that we intend to do our best to do, it right going forward.

> > > Are there any other sticking points?
> > >=20
> > >=20
> > The conditional passing of the vfsmnt mount in the vfs, as done in this
> > patch series, has received a NAK.  This problem results from NFS passing
> > a NULL nameidata into the vfs.  We have a second patch series that we
> > have posted for discussion that addresses this by splitting the nameida=
ta
> > struct.
> > Message-Id: <20070626231510.883881222@suse.de>
> > Subject: [RFD 0/4] AppArmor - Don't pass NULL nameidata to
> > vfs_create/lookup/permission IOPs
> >=20
> > other issues that have been raised are:
> > - AppArmor does not currently mediate IPC and network communications.
> >   Mediation of these is a wip
> > - the use of d_path to generate the pathname used for mediation when a
> >   file is opened.
> >   - Generating the pathname using a reverse walk is considered ugly
> >   - A buffer is alloced to store the generated path name.
> >   - The  buffer size has a configurable upper limit which will cause
> >     opens to fail if the pathname length exceeds this limit.  This
> >     is a fail closed behavior.
> >   - there have been some concerns expressed about the performance
> >     of this approach
> >   We are evaluating our options on how best to address this issue.
>=20
> OK, useful summary, thanks.  I'd encourage you to proceed apace.

thankyou

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGggcpi/GH5xuqKCcRAs3uAJoDj8x0wu++s9gmSZMvNjzojfuc4wCgi5PQ
R4Tn6KssPQazOnr2fry4+i8=
=flXd
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764849AbXJZSZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764849AbXJZSZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbXJZSY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:24:56 -0400
Received: from ns.suse.de ([195.135.220.2]:42514 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108AbXJZSYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:24:55 -0400
Date: Fri, 26 Oct 2007 11:26:05 -0700
From: John Johansen <jjohansen@suse.de>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: jjohansen@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 35/45] Allow permission functions to tell between parent and leaf checks
Message-ID: <20071026182605.GB32415@suse.de>
References: <20071026064024.243943043@suse.de> <20071026064051.877606581@suse.de> <1193401943.11953.3.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Content-Disposition: inline
In-Reply-To: <1193401943.11953.3.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 26, 2007 at 08:32:23AM -0400, Stephen Smalley wrote:
> On Thu, 2007-10-25 at 23:40 -0700, jjohansen@suse.de wrote:
> > plain text document attachment (parent-permission.diff)
> > Set the LOOKUP_CONTINUE flag when checking parent permissions. This all=
ows
> > permission functions to tell between parent and leaf checks.
> >=20
> > Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> > Signed-off-by: John Johansen <jjohansen@suse.de>
> >=20
> > ---
> >  fs/namei.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> >=20
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -1472,6 +1472,10 @@ static int may_delete(struct inode *dir,
> >  	BUG_ON(victim->d_parent->d_inode !=3D dir);
> >  	audit_inode_child(victim->d_name.name, victim, dir);
> > =20
> > +#if 0
> > +	if (nd)
> > +		nd->flags |=3D LOOKUP_CONTINUE;
> > +#endif
>=20
> #if 0?
>=20
Oops, thanks I missed that one.

regards
john

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFHIjE9i/GH5xuqKCcRAiJBAJsGZNf973fNCEYcMbXzADKPyhlmlwCeIYoY
OnOthvY9BZthzFEPYTKBgDk=
=5E5F
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbXFVHlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbXFVHlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbXFVHl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:41:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbXFVHl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:41:26 -0400
Date: Fri, 22 Jun 2007 00:40:44 -0700
From: John Johansen <jjohansen@suse.de>
To: James Morris <jmorris@namei.org>
Cc: Chris Mason <chris.mason@oracle.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Lars Marowsky-Bree <lmb@suse.de>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070622074044.GA14593@suse.de>
References: <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706212044590.2100@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 21, 2007 at 09:06:40PM -0400, James Morris wrote:
> On Thu, 21 Jun 2007, Chris Mason wrote:
>=20
> > > The incomplete mediation flows from the design, since the pathname-ba=
sed
> > > mediation doesn't generalize to cover all objects unlike label- or
> > > attribute-based mediation.  And the "use the natural abstraction for
> > > each object type" approach likewise doesn't yield any general model or
> > > anything that you can analyze systematically for data flow.
> >=20
> > This feels quite a lot like a repeat of the discussion at the kernel
> > summit.  There are valid uses for path based security, and if they don't
> > fit your needs, please don't use them.  But, path based semantics alone
> > are not a valid reason to shut out AA.
>=20
> The validity or otherwise of pathname access control is not being=20
> discussed here.
>=20
> The point is that the pathname model does not generalize, and that=20
> AppArmor's inability to provide adequate coverage of the system is a=20
> design issue arising from this.
>=20
As we have previously stated we are not using pathnames for IPC.  The
use of pathnames for file access mediation is not a design issue that in
anyway prevents us from extending AppArmor to mediate IPC or networking.

The current focus is making the revision necessary for AppArmor's file
mediation at which point we can focus on finishing of the network
and IPC support.

> Recall that the question asked by Lars was whether there were any=20
> outstanding technical issues relating to AppArmor.
>=20
> AppArmor does not and can not provide the level of confinement claimed by=
=20
> the documentation, and its policy does not reflect its actual confinement=
=20
> properties.  That's kind of a technical issue, right?
>=20
AppArmor currently controls file and capabilities, which was explicitly
stated in the documentation submitted with the patches.  And it has
been posted before that network and IPC mediation are a wip.



--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGe3z8i/GH5xuqKCcRAn7cAJ4+Dvbu3mahZ6wEn241szjdhpqeSQCdELBI
nrB6sDkR8O8Mb07U25EnKVc=
=wWNZ
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--

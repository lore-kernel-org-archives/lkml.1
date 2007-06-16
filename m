Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbXFPAH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbXFPAH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 20:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbXFPAHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 20:07:21 -0400
Received: from ns.suse.de ([195.135.220.2]:59149 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082AbXFPAHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 20:07:19 -0400
Date: Fri, 15 Jun 2007 17:07:15 -0700
From: Seth Arnold <seth.arnold@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070616000715.GO3564@suse.de>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Greg KH <greg@kroah.com>, Crispin Cowan <crispin@novell.com>,
	Andreas Gruenbacher <agruen@suse.de>,
	Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615233314.GN3564@suse.de> <20070615233914.GF2616@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Eu9PQ+LfZADlAtIa"
Content-Disposition: inline
In-Reply-To: <20070615233914.GF2616@elf.ucw.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Eu9PQ+LfZADlAtIa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 16, 2007 at 01:39:14AM +0200, Pavel Machek wrote:
> > Pavel, please focus on the current AppArmor implementation. You're
> > remembering a flaw with a previous version of AppArmor. The pathnames
> > constructed with the current version of AppArmor are consistent and
> > correct.
>=20
> Ok, I did not know that this got fixed.
>=20
> How do you do that? Hold a lock preventing renames for a whole time
> you walk from file to the root of filesystem?

We've improved d_path() to remove many of its previous shortcomings:

eb3dfb0cb1f4a44e2d0553f89514ce9f2a9fcaf1

--Eu9PQ+LfZADlAtIa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGcymz+9nuM9mwoJkRAhivAKCgrByUWMM2J3Vd8CxyUjpyYzE2xACfb28T
yXsnfsri7KgHKbzFkZN/82Q=
=Lhhj
-----END PGP SIGNATURE-----

--Eu9PQ+LfZADlAtIa--

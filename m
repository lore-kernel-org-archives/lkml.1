Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbXKMBUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbXKMBUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 20:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbXKMBT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 20:19:59 -0500
Received: from mx1.suse.de ([195.135.220.2]:56487 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306AbXKMBT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 20:19:58 -0500
Date: Mon, 12 Nov 2007 17:20:14 -0800
From: John Johansen <jjohansen@suse.de>
To: Crispin Cowan <crispin@crispincowan.com>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
Message-ID: <20071113012014.GA16006@suse.de>
References: <473380AD.5070801@crispincowan.com> <20071110220455.GB24195@gallifrey> <47362C7C.2050202@crispincowan.com> <20071110222414.GC24195@gallifrey> <47363381.4030103@crispincowan.com> <20071110232545.GD24195@gallifrey> <4738E6E3.5090404@crispincowan.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <4738E6E3.5090404@crispincowan.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 12, 2007 at 03:50:59PM -0800, Crispin Cowan wrote:
> Dr. David Alan Gilbert wrote:
> > * Crispin Cowan (crispin@crispincowan.com) wrote:
> >  =20
> >> I mostly don't see this as a serious limitation, because almost everyo=
ne
> >> has their own workstation, and thus has root on that workstation. There
> >> are 2 major exceptions:
> >>
> >>     * Schools, where the "workstations" are thin client X terminals and
> >>       everyone is logged into a giant shared machine. Sorry, AppArmor =
is
> >>       not a good choice for that environment, but it is a pretty scarce
> >>       environment.
> >>     * Enterprises, where workers get their own workstation, but they
> >>       don't get root. Well, the reason the worker doesn't get root is
> >>       the enterprise doesn't trust them with it, and so not letting th=
em
> >>       edit security policy is probably a good idea.
> >>    =20
> > I don't actually see your distinction here between those two environmen=
ts;
> > why does it matter if there is one non-priveliged user or many?
> >  =20
> Because it is easier to solve if there is only one non-privileged user:
> you just give them privilege (fun with chmod and sudo) to edit the
> system policies, and you're done (assuming you are happy allowing the
> non-privileged user to edit policy at all).
>=20
> If there are lots of non-privileged users sharing a computer, then I
> submit that solutions are either insecure, intractable, or purely
> restrictive.
>=20
yep, it needs to be purely restrictive

> >> Can you explain why you want a non-privileged user to be able to edit
> >> policy? I would like to better understand the problem here.
> >>    =20
> > I think it might depend on how strict the users starting point is;
> > you could say:
> >    1 This document editor can read and write any part of the users home
> >      directory other than the . files.
> >
> > or you could say:
> >    2 This document editor can read any files but only write to the
> >      'Documents directory'.
> >
> > If the adminisrator set something up with (2) as the starting point it
> > would seem reasonable for the user to be able to add the ability to edit
> > documents in extra directories for their style of organising documents
> > they work on; but they would be restricted in what they could add
> > so that they couldn't add the ability to write to their settings
> > files.
> >  =20
> Ok, I can see where that would be useful in theory. But solving it is
> VERY hard in practice, and AppArmor is not attempting to address this
> problem of user extensibility of mandatory access controls.
>=20
Well at least its not on Crispin's list.  It is something I have been
interested in for a long time.  I can't say when or it will happen
as I need to find some, ever elusive, spare time to work on it.

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQFHOPvOi/GH5xuqKCcRArcpAJ92OqSOtHd9yRsBuEJo1YDJAt1B6gCfXACv
RnwrU0IUqKgsO+//5JHH1W8=
=LdKD
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--

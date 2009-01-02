Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbZABURa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbZABURa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbZABURT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:17:19 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59838 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZABURS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:17:18 -0500
From: Martin Steigerwald <Martin@Lichtvoll.de>
To: tux3@tux3.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Date: Fri, 2 Jan 2009 21:17:14 +0100
User-Agent: KMail/1.9.9
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Phillips <phillips@phunq.net>
References: <200812301935.49303.phillips@phunq.net> <200812311109.12635.Martin@lichtvoll.de> <495BAED9.3000305@gmail.com> (sfid-20090102_152147_492889_6D60D0EE)
In-Reply-To: <495BAED9.3000305@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2482991.KrMofvYLoR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901022117.24504.Martin@Lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2482991.KrMofvYLoR
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch 31 Dezember 2008 schrieb Justin P. Mattock:
> Martin Steigerwald wrote:
> > Am Mittwoch 31 Dezember 2008 schrieb Justin P. Mattock:
> >> Daniel Phillips wrote:
> >>> On Tuesday 30 December 2008 23:34, sniper wrote:
> >>>> Great, I have mounted tux3 filesystem under UML with stuffs in
> >>>> this mail, but I still can't debug it with gdb. Anyone gives me
> >>>> suggestion?
> >>>
> >>> You just have to give a "cont" command a bunch of times and you
> >>> will eventually get to a command prompt.  The reason for this is,
> >>> uml uses the segfault interrupt as part of its machine simulation,
> >>> and there is no exsiting way for uml and gdb to communicate in such
> >>> a way that uml can recognize that the interrupt came from its own
> >>> code and filter it.
> >
> > [...]
> >
> >> Hmm.. seems like a redundancy;
> >> Anyways I looked at you're site, but am still
> >> confused at what tux3 is: what is tux3?
> >>
> >> (at first I thought it was  a  video game, but was wrong);
> >> can I use tux3 to secure a linux system or is it for
> >> something else?
> >
> > Hmmm, I thought
> >
> > ---------------------------------------------------------------------
> > Tux3 is a write-anywhere, atomic commit, btree-based versioning
> > filesystem. It is the spiritual and moral successor of Tux2, the most
> > famous filesystem that was never released. The main purpose of Tux3
> > is to embody Daniel Phillips's new ideas on storage data versioning.
> > The secondary goal is to provide a more efficient snapshotting and
> > replication method for the Zumastor NAS project, and a tertiary goal
> > is to be better than ZFS.
> > ---------------------------------------------------------------------
> > http://tux3.org/
> >
> > was pretty clear. What are you missing?
> >
> > Ciao,
>
> I guess this is what is confusing to me:
> atomic commit, btree-based versioning.

Ah, the buzz words. ;)

The tux3 mailing list contains quite some design notes about these=20
concepts. I think others can give better answers about these concepts - I=20
think I understood what it is for, not the implementation details. But=20
basically "atomic commit" is a strategy to have the filesystem always in=20
a consistent state and btree-based versioning allows to keep different=20
versions of a file / directory around. And unlike other filesystem tux3=20
has this per inode and not for the complete filesystem. At least if I=20
understand correctly.

But at least it should clear that tux3 is a filesystem and not a video=20
game ;).

> irregardless about how it's worded,
> I'm wondering if I should use this mechanism,
> or not.

Right now its still in heavy development and not of release quality. I.e.=20
something to play around and test with if you want.=20

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2482991.KrMofvYLoR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAkledksACgkQmRvqrKWZhMdmaACYo6Lp4EKYarKvv5FZN0QanF64
fgCghg08PrharEqK6WRSk25oIGhOu5g=
=3bZF
-----END PGP SIGNATURE-----

--nextPart2482991.KrMofvYLoR--

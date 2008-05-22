Return-Path: <linux-kernel-owner+w=401wt.eu-S937636AbYEVBYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937636AbYEVBYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 21:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932581AbYEVBYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 21:24:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39166 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764582AbYEVBYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 21:24:21 -0400
Date: Thu, 22 May 2008 11:24:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] HG -> GIT migration
Message-Id: <20080522112412.4a8406fd.sfr@canb.auug.org.au>
In-Reply-To: <48343FF4.8090107@keyaccess.nl>
References: <Pine.LNX.4.61.0805201314190.1798@tm8103-a.perex-int.cz>
	<200805211430.06653.linux@audioscience.com>
	<Pine.LNX.4.61.0805210805080.1798@tm8103-a.perex-int.cz>
	<s5hve18vtml.wl%tiwai@suse.de>
	<483415E7.5080402@keyaccess.nl>
	<s5hfxsbx27f.wl%tiwai@suse.de>
	<48341DF5.4090307@keyaccess.nl>
	<Pine.LNX.4.61.0805211517290.1798@tm8103-a.perex-int.cz>
	<48343465.2030905@keyaccess.nl>
	<s5h8wy3wvyv.wl%tiwai@suse.de>
	<48343FF4.8090107@keyaccess.nl>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_May_2008_11_24_12_+1000_w+cl=/KSI.hNI1Ox"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_May_2008_11_24_12_+1000_w+cl=/KSI.hNI1Ox
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rene,

On Wed, 21 May 2008 17:29:56 +0200 Rene Herman <rene.herman@keyaccess.nl> w=
rote:
>
> On 21-05-08 16:52, Takashi Iwai wrote:
>=20
> > At Wed, 21 May 2008 16:40:37 +0200, Rene Herman wrote:
>=20
> >> I'm also still frequently trying to figure out an/the efficient way of=
=20
> >> using GIT but it does seem it's not just a matter of "pure downstream"=
=20
> >> (which I do believe ALSA has few enough of to not make this be a huge=
=20
> >> problem). For example linux-next is also going to want to pull in ALSA=
=20
> >> and say it does, finds a trivial conflict with the trivial tree that i=
t=20
> >> also pulls in and fixes things up. If you rebase that which linux-next=
=20
> >> pulls from I believe it will have to redo the fix next time it pulls=20
> >> from you since it's getting all those new changesets.
> >>
> >> I guess this can be avoided by just not rebasing that which linux-next=
=20
> >> is pulling... and I in fact don't even know if linux-next does any=20
> >> conflict resolution itself, trivial or otherwise.
> >=20
> > I thought linux-next does fresh merges at each time, thus it doesn't
> > matter whether a subsystem tree is rebased or not...
>=20
> Let's ask...
>=20
> Fresh merges at each release boundary certainly but if it drops/remerges=
=20
> each subsystem when a bug in its for-next branch is found (a supposedly=20
> non rare occurence) all the hopefully hundreds or even thousands of=20
> linux-next pullers/testers would seem to have to deal with all those=20
> completely new merges everytime as well. I'd hope linux-next during a=20
> single release would just pull in the one fix (the subsystem's for-linus=
=20
> branch can still fold it in).

Linux-next is rebuilt every day based on Linus' current kernel.  I merge
all the trees I have been told about and fixup minor conflicts (sometimes
reverting commits, sometimes applying patches).  So everyday, linux-next
is completely new.  I do not care if the trees I am merging get rebased.

I have only had a couple of occasions when the merge conflicts were so
bad that I had to drop a whole tree, but they were fixed up the next day.

Linux-next has only one downstream - Andrew's mm tree and he bases on a
particular day's linux-next tree each time he rebuilds mm.  Testers just
need to take the complete tree (which isn't too bad if you are using git
since all the linux-next trees share a lot of objects).

Does that answer your question?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_May_2008_11_24_12_+1000_w+cl=/KSI.hNI1Ox
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINMs/TgG2atn1QN8RAvgwAJ0dCmjGSNIiJoX07NDgk3vrGK3o0ACgmO6H
9B3JDkl1CO/0q4dxKpPJ9N4=
=XYG9
-----END PGP SIGNATURE-----

--Signature=_Thu__22_May_2008_11_24_12_+1000_w+cl=/KSI.hNI1Ox--

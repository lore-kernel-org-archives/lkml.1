Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbZILLsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbZILLsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 07:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbZILLsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 07:48:37 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45296 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbZILLsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 07:48:36 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Keep kthreads at default priority
Date: Sat, 12 Sep 2009 13:48:38 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc7-tp42-toi-3.0.1-04741-g57e61c0; KDE/4.3.1; i686; ; )
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, mingo@redhat.com,
       hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
References: <1252486344.28645.18.camel@marge.simson.net> <1252516001.22918.6.camel@laptop> <1252517696.6220.9.camel@marge.simson.net> (sfid-20090909_202324_097104_7D52F860)
In-Reply-To: <1252517696.6220.9.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1823807.TIOLOTiGiE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909121348.38528.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1823807.TIOLOTiGiE
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch 09 September 2009 schrieb Mike Galbraith:
> On Wed, 2009-09-09 at 19:06 +0200, Peter Zijlstra wrote:
> > On Wed, 2009-09-09 at 09:55 -0700, Dmitry Torokhov wrote:
> > > On Wed, Sep 09, 2009 at 03:37:34PM +0000, tip-bot for Mike Galbraith=
=20
wrote:
> > > > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > > > index eb8751a..5fe7099 100644
> > > > --- a/kernel/kthread.c
> > > > +++ b/kernel/kthread.c
> > > > @@ -16,8 +16,6 @@
> > > >  #include <linux/mutex.h>
> > > >  #include <trace/events/sched.h>
> > > >
> > > > -#define KTHREAD_NICE_LEVEL (-5)
> > > > -
> > >
> > > Why don't we just redefine it to 0? We may find out later that we'd
> > > still prefer to have kernel threads have boost.
> >
> > Seems sensible, also the traditional reasoning behind this nice level
> > is that kernel threads do work on behalf of multiple tasks. Its a
> > kind of prio ceiling thing.
>=20
> True.  None of our current threads are heavy enough to matter much.

Does it make sense to have this as a tunable? Where does it matter? Server=
=20
workloads?

(Oh no, not another tunable I can hear you yell;-).

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1823807.TIOLOTiGiE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqripYACgkQmRvqrKWZhMdmFACfW0rec0qyv1wBndouyJrFGycW
bAEAmgNwWxAqSwmAzGRBmRCiYMiOsdGT
=d2cp
-----END PGP SIGNATURE-----

--nextPart1823807.TIOLOTiGiE--

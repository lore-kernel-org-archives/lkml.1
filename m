Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZIJVTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZIJVTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbZIJVTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:19:35 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56263 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbZIJVTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:19:34 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Thu, 10 Sep 2009 23:19:36 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc7-tp42-toi-3.0.1-04741-g57e61c0; KDE/4.3.1; i686; ; )
References: <20090906205952.GA6516@elte.hu> <200909102239.48750.Martin@lichtvoll.de> <20090910204252.GA28230@elte.hu> (sfid-20090910_225409_920256_CA47A016)
In-Reply-To: <20090910204252.GA28230@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1921199.FgAOK1sKgH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909102319.36524.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1921199.FgAOK1sKgH
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Donnerstag 10 September 2009 schrieb Ingo Molnar:
> * Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Am Donnerstag 10 September 2009 schrieb Ingo Molnar:
> > > * Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > > > Am Mittwoch 09 September 2009 schrieb Peter Zijlstra:
> > > > > On Wed, 2009-09-09 at 12:05 +0300, Nikos Chantziaras wrote:
> > > > > > Thank you for mentioning min_granularity.  After:
> > > > > >
> > > > > >    echo 10000000 > /proc/sys/kernel/sched_latency_ns
> > > > > >    echo 2000000 > /proc/sys/kernel/sched_min_granularity_ns
> > > > >
> > > > > You might also want to do:
> > > > >
> > > > >      echo 2000000 >
> > > > > /proc/sys/kernel/sched_wakeup_granularity_ns
> > > > >
> > > > > That affects when a newly woken task will preempt an already
> > > > > running task.
> > > >
> > > > Heh that scheduler thing again... and unfortunately Col appearing
> > > > to feel hurt while I am think that Ingo is honest on his offer on
> > > > collaboration...
> > > >
> > > > While it makes fun playing with that numbers and indeed
> > > > experiencing subjectively a more fluid deskopt how about just a
> > > >
> > > > echo "This is a f* desktop!" > /proc/sys/kernel/sched_workload
> > >
> > > No need to do that, that's supposed to be the default :-) The knobs
> > > are really just there to help us make it even more so - i.e. you
> > > dont need to tune them. But it really relies on people helping us
> > > out and tell us which combinations work best ...
> >
> > Well currently I have:
> >
> > shambhala:/proc/sys/kernel> grep "" sched_latency_ns
> > sched_min_granularity_ns sched_wakeup_granularity_ns
> > sched_latency_ns:100000
> > sched_min_granularity_ns:200000
> > sched_wakeup_granularity_ns:0
> >
> > And this give me *a completely different* desktop experience.
>=20
> what is /debug/sched_features - is NO_NEW_FAIR_SLEEPERS set? If not
> set yet then try it:
>=20
>   echo NO_NEW_FAIR_SLEEPERS > /debug/sched_features
>=20
> that too might make things more fluid.

Hmmm, need to mount that first. But not today, cause I have to dig out on=20
how to do it. Have to pack some things for tomorrow. And then sleep time.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1921199.FgAOK1sKgH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqpbWgACgkQmRvqrKWZhMdPBQCcC3wkHlLHi8n3lGyGpDXJIsGt
VtAAn1rastV0zLbT7ZmJt+rOHMgCbURm
=BtFz
-----END PGP SIGNATURE-----

--nextPart1921199.FgAOK1sKgH--

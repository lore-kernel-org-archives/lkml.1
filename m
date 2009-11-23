Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbZKWUfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbZKWUfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 15:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZKWUe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 15:34:59 -0500
Received: from panacea.frsk.net ([92.243.16.10]:36178 "EHLO panacea.frsk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbZKWUe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 15:34:58 -0500
X-Greylist: delayed 1949 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 15:34:58 EST
From: Henrik Austad <henrik@austad.us>
To: Peter Zijlstra <peterz@infradead.org>
Date: Mon, 23 Nov 2009 21:02:03 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Jon Tore Hafstad <jontore@gmail.com>, linux-kernel@vger.kernel.org,
       dhaval.giani@gmail.com, mingo@elte.hu, tglx@linutronix.de,
       bbb@cs.unc.edu, jmc@cs.unc.edu, Jeff Dike <jdike@addtoit.com>
References: <78b8ce680911181211k6c15a976u52186b5849224040@mail.gmail.com> <1258985295.4531.496.camel@laptop>
In-Reply-To: <1258985295.4531.496.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2781745.HptGoNdTSc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200911232102.07419.henrik@austad.us>
X-SA-Exim-Connect-IP: 129.241.93.108
X-SA-Exim-Mail-From: henrik@austad.us
Subject: Re: LinSched updated to current linux kernel version
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on panacea.frsk.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2781745.HptGoNdTSc
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 23. November 2009 15.08.15 Peter Zijlstra wrote:
> On Wed, 2009-11-18 at 21:11 +0100, Jon Tore Hafstad wrote:
> >  Hi all
> >
> > I wish to inform you about an update of LinSched (The Linux Scheduler
> > Simulator([1])) I'm currently working on.
> >
> > =3D=3D Motivation =3D=3D
> > I wished to implement different EDF schedulers to gain a better
> > understanding of kernel internals as well as scheduling dynamics. I
> > got some feedback from Henrik Austad  that LinSched was a tool that
> > made implementing a scheduler in to  the linux kernel easier,  since
> > the code compiles in a fraction of the time the kernel does (Yes, I
> > know you can pull all sorts of tricks and tweaks in order to speed up
> > a kernel compilation), a segfault will be a segfault, and not a kernel
> > oops ;),and the full range of debuggers and memory analyzers will be
> > available.
>=20
> I would have expected people to use UML for this (User-Mode-Linux, not
> the draw lots of silly pictures thing).

What is the current status of UML - is anyone actually working on that thes=
e=20
days?

> The main draw-back is that UML doesn't currently support SMP and any
> interesting preemption modes, but adding that to UML would help out more
> people -- I know the VM (virtual Memory, not the machine thing) people
> used to use UML for exactly these reasons, easy gdb, etc..

Well, another drawback of UML is the size. The whole point with LinSched is=
 to=20
be *lightweight* while still being accurate. By accurate I mean that code=20
written and tested with LinSched should work nearly out of the box when pla=
ced=20
in the kernel.

LinSched is all about scheduling - nothing else. To be able to compile the=
=20
code in a fraction of a second, and then simulate hours worth of computing =
(or=20
at least the task-switches) can be *very* useful.=20

IMHO, making it easy to test new scheduling algorithms is a very neat way o=
f=20
attracting new kernel/scheduler hackers (as well as testing all sorts of cr=
azy=20
algorithms).

Just my $0.02

=2D-=20
     henrik

--nextPart2781745.HptGoNdTSc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAksK6jsACgkQ6k5VT6v45lmn5wCghhXWM8YS29rFJqekE5tPhFQF
eyAAn3Vm3ZyolhViOHniSBPRdvBYPhpk
=ZY+4
-----END PGP SIGNATURE-----

--nextPart2781745.HptGoNdTSc--

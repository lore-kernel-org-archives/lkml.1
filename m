Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607Ab0A0QYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0A0QYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806Ab0A0QYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:24:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab0A0QYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:24:19 -0500
Date: Wed, 27 Jan 2010 10:23:54 -0600
From: Clark Williams <williams@redhat.com>
To: RT <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Carsten Emde <ce@ceag.ch>,
       Uwe =?ISO-8859-1?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>,
       John Kacur <jkacur@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [rt-tests] version 0.63 available
Message-ID: <20100127102354.0b5c0f9d@torg>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VD65l3F.iQiLEE3vtyYxpRe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VD65l3F.iQiLEE3vtyYxpRe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


The latest version of rt-tests is now available as a tarball from:

http://www.kernel.org/pub/linux//kernel/people/clrkwllms/rt-tests/rt-tests-=
0.63.tar.bz2

Also available in my git repo:

git://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-tests.git

under tag v0.63

This version includes a new option: --numa, which is a counterpart to
the recently introduced --smp option.=20

The --smp option is a shorthand for:  -t -a -n, meaning that one
measurement thread is created per active CPU and is affined to that cpu
and that clock_nanosleep is used for measurements.=20

The --numa option does the same options as --smp, but also makes calls
into libnuma to ensure that measurement threads are always bound to the
memory node that is local to it's cpu (avoiding cross-node memory
references). Each measurement thread's stack and major data structures
are allocated from the local memory node.

Note that to actually use --numa mode, you must pass NUMA=3D1 to the make
build command:

	$ make NUMA=3D1

This is for all you embedded guys that could care less about NUMA :)

Other changes from previous releases are that the hwlatdetect test has
been moved to the python site-library (so that other tests can import
it) and then symlinked to /usr/bin/hwlatdetect. Also, copyright
messages have been updated in the source files (thanks Uwe).=20

Clark

--Sig_/VD65l3F.iQiLEE3vtyYxpRe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAktgaKEACgkQHyuj/+TTEp1tZwCgm3OiZRwEFlf0ulesae0nFznM
ILYAn372JoaLxroeo5kXzJFD/bFnOP7S
=zvDH
-----END PGP SIGNATURE-----

--Sig_/VD65l3F.iQiLEE3vtyYxpRe--

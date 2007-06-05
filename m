Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbXFERfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbXFERfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbXFERfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:35:11 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49793 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbXFERfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:35:10 -0400
Date: Tue, 5 Jun 2007 10:36:47 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070605173647.GC12782@tree.beaverton.ibm.com>
References: <20070601004427.GI30788@tree.beaverton.ibm.com> <20070605172310.GD17143@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <20070605172310.GD17143@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 05, 2007 at 10:23:10AM -0700, Siddha, Suresh B wrote:

> Darrick, I see a kernel bug in this area(which is already filled with bug=
s,
> and I am looking into ways to fix them). Are you making sure that
> between step-1 and step-2, that interrupts actually started arriving at c=
pu1?
>=20
> i.e., do step-1 and wait till the irq's start hitting at cpu1. At this po=
int
> do step-2 and let us know if you still hit this bug?

Yes, the bug only happens after CPU1 begins to receive interrupts.

> > There exists a similar scenario.  Set the IRQ affinity to a bunch of
> > CPUs, watch /proc/interrupts to see which CPU is actually servicing the
> > interrupts, then offline that CPU.  The kernel does not reroute the IRQ
> > to any of the other CPUs and the device also hangs.
>=20
> Is this a theory or did you observe this problem happening?

Nope, I've observed this situation too.

--D

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGZZ8va6vRYYgWQuURAi1pAJ97NThlp1Jwkvqr3Rv6i8ut2sUsIgCaA1no
s/u1pWReUCNLk0f1bFymshA=
=O5EK
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--

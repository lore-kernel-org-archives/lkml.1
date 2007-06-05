Return-Path: <linux-kernel-owner+w=401wt.eu-S1765565AbXFEUI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765565AbXFEUI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 16:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbXFEUIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 16:08:19 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59085 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbXFEUIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 16:08:18 -0400
Date: Tue, 5 Jun 2007 13:09:54 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070605200954.GE12782@tree.beaverton.ibm.com>
References: <20070601004427.GI30788@tree.beaverton.ibm.com> <20070605172310.GD17143@linux-os.sc.intel.com> <20070605173647.GC12782@tree.beaverton.ibm.com> <20070605181342.GE17143@linux-os.sc.intel.com> <20070605183300.GD12782@tree.beaverton.ibm.com> <20070605184015.GF17143@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W5WqUoFLvi1M7tJE"
Content-Disposition: inline
In-Reply-To: <20070605184015.GF17143@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 05, 2007 at 11:40:15AM -0700, Siddha, Suresh B wrote:

> Does this problem happen only under certain stress or something simple, l=
ike
>=20
> boot the kernel
> echo 2 > /proc/irq/114/smp_affinity
> wait for irq to hit the cpu1.
> echo 0 > /sys/devices/system/cpu/cpu1/online
>=20
> will immmd trigger this?

The system is not under any stress at all.

--D

--W5WqUoFLvi1M7tJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGZcMSa6vRYYgWQuURAvg5AJ0ZxwBOqrXB798YrFkW+ipBFtEpiQCgkgr/
9NIK925OUpXiQmr50SqhpHw=
=1Lpr
-----END PGP SIGNATURE-----

--W5WqUoFLvi1M7tJE--

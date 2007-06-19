Return-Path: <linux-kernel-owner+w=401wt.eu-S1765958AbXFSAua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765958AbXFSAua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 20:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763135AbXFSAuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 20:50:22 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38421 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762453AbXFSAuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 20:50:21 -0400
Date: Mon, 18 Jun 2007 17:51:36 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070619005136.GF9751@tree.beaverton.ibm.com>
References: <20070605200954.GE12782@tree.beaverton.ibm.com> <20070605211451.GG17143@linux-os.sc.intel.com> <20070605235707.GB16074@tree.beaverton.ibm.com> <20070606013759.GI17143@linux-os.sc.intel.com> <20070606185829.GA26062@tree.beaverton.ibm.com> <20070606193514.GN17143@linux-os.sc.intel.com> <20070606231642.GH13751@tree.beaverton.ibm.com> <20070608005726.GO17143@linux-os.sc.intel.com> <20070618223819.GD9751@tree.beaverton.ibm.com> <20070618235434.GB7160@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rMWmSaSbD7nr+du9"
Content-Disposition: inline
In-Reply-To: <20070618235434.GB7160@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--rMWmSaSbD7nr+du9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 18, 2007 at 04:54:34PM -0700, Siddha, Suresh B wrote:

> > <call to set_affinity>
> > [  256.298787] irq=3D4341 affinity=3Dd
> > <ethernet on irq 4341 stops working>
>=20
> And just to make sure, at this point, your MSI irq 4341 affinity
> (/proc/irq/4341/smp_affinity) still points to '2'?

Actually, it's 0xD.  From the kernel's perspective the mask has been
updated (and I even stuck a printk into set_msi_irq_affinity to verify
that the writes are happening) but ... the hardware doesn't seem to
reflect this.  I also tried putting read_msi_msg right afterwards to
compare contents, though it complained about all the MSIs _except_ for
4341.  (Of course, I could just be way off on the effectiveness of
that.)

--D

--rMWmSaSbD7nr+du9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGdyiYa6vRYYgWQuURAvZFAKCxNCKOpR2BRLOWJTCa2mhwxfmmkgCggQZ8
0rZW9OwNvofFNH+sJnGQWZA=
=NA++
-----END PGP SIGNATURE-----

--rMWmSaSbD7nr+du9--

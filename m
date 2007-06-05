Return-Path: <linux-kernel-owner+w=401wt.eu-S1761931AbXFESbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761931AbXFESbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbXFESb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:31:27 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46997 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbXFESb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:31:26 -0400
Date: Tue, 5 Jun 2007 11:33:01 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070605183300.GD12782@tree.beaverton.ibm.com>
References: <20070601004427.GI30788@tree.beaverton.ibm.com> <20070605172310.GD17143@linux-os.sc.intel.com> <20070605173647.GC12782@tree.beaverton.ibm.com> <20070605181342.GE17143@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Content-Disposition: inline
In-Reply-To: <20070605181342.GE17143@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 05, 2007 at 11:13:42AM -0700, Siddha, Suresh B wrote:
> I see. Your system should have 4 or 8 logical cpu's right. So you must be
> using logical flat mode, right?

I believe so.  The system has two Xeon 5150s with an Intel 5000 chipset
of some sort.

> When this bug happens, what does /proc/irq/<irq-no>/smp_affinity show?

root@elm3a188:~# cat /proc/irq/114/smp_affinity=20
02

--D

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGZaxca6vRYYgWQuURAhl4AJ9LjGZfdDx2UT4UKNt4t7HVVfa+tgCfWtn9
hYnUZP52Ns3sBAs2kXOwOhg=
=WH4k
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--

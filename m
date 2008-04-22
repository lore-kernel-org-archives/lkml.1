Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYDVEnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYDVEnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 00:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYDVEnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 00:43:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44079 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYDVEnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 00:43:08 -0400
Date: Tue, 22 Apr 2008 14:42:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: linux-next: Intel iommu: new warning
Message-Id: <20080422144258.9564e2fa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta2 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Apr_2008_14_42_58_+1000_M=LP6bpJKp+vg5hA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2008_14_42_58_+1000_M=LP6bpJKp+vg5hA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

Commit 2be621498d461b63ca6124f86e3b9582e1a8e722 ("x86: dma-ops on highmem
fix") in Linus' tree introduced a new warning (noticed in the x86_64
allmodconfig build of linux-next):

drivers/pci/intel-iommu.c:2240: warning: initialization from incompatible p=
ointer type

Which I think points at an instance of map_single that needs updating.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Apr_2008_14_42_58_+1000_M=LP6bpJKp+vg5hA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIDWzWTgG2atn1QN8RAr0CAKCNsp34rnMgrHFt5ubjhG5bOD6rrgCdEP7O
3A6LB73qcxFzBNi39MNDD2Q=
=50Pd
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2008_14_42_58_+1000_M=LP6bpJKp+vg5hA--

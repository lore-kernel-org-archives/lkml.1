Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456Ab0ARHuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0ARHuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 02:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596Ab0ARHuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 02:50:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46486 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab0ARHuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:50:04 -0500
Date: Mon, 18 Jan 2010 18:49:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the driver-core tree with Linus' tree
Message-Id: <20100118184956.ea783994.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jan_2010_18_49_56_+1100_GQxd/yuib4/=Hioa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jan_2010_18_49_56_+1100_GQxd/yuib4/=Hioa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/base/memory.c between commit
8ff410daa009c4b44be445ded5b0cec00abc0426 ("sysdev: fix prototype for
memory_sysdev_class show/store functions") from Linus' tree and commits
95f4918fb2826dd7fc7be8a375ee0b71e8276a62 ("sysdev: Fix type of sysdev
class attribute in memory driver") and
18a994bc1df640e77b853af5b6a175d6871b449f ("driver-core: Add attribute
argument to class_attribute show/store") from the driver-core tree.

Not a big suprise.  I fixed it up by using the driver-core tree version
(effectively reverting the version in Linus' tree).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jan_2010_18_49_56_+1100_GQxd/yuib4/=Hioa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktUEqQACgkQjjKRsyhoI8yITwCgoiZPsem7ruxt7ZkixZRjziAG
idAAnjWMKk2w56KgUmPpoIbI7cxetNl/
=LGnl
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jan_2010_18_49_56_+1100_GQxd/yuib4/=Hioa--

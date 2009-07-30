Return-Path: <linux-kernel-owner+w=401wt.eu-S1751614AbZG3Fl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbZG3Fl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 01:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbZG3Fl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 01:41:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41990 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbZG3Fl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 01:41:57 -0400
Date: Thu, 30 Jul 2009 15:41:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: linux-next: manual merge of the edac-amd tree with the rr tree
Message-Id: <20090730154150.d4c326b5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Jul_2009_15_41_50_+1000_uKzOXmkgptQLYFdS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jul_2009_15_41_50_+1000_uKzOXmkgptQLYFdS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Borislav,

Today's linux-next merge of the edac-amd tree got a conflict in
include/linux/topology.h between commit
11c0109a8c24b27fd6eff8c2c0ddca598675212d
("cpumask:remove-topology_core_siblings-and-topology_thread_siblings-core")
from the rr tree and commit 86aebc88b40884510c914ad71e81c8536a15052e
("topology: introduce cpu_node information for multi-node processors")
from the edac-amd tree.

The latter adds topology_cpu_node_siblings() which is not needed (the
former makes it clear that the _cpumask versions of these should be used
instead).  I fixed it up and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Jul_2009_15_41_50_+1000_uKzOXmkgptQLYFdS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpxMp4ACgkQjjKRsyhoI8xnaACeOdvkyXQluAfhaEIA57Tc3kKj
diYAn3DSby5g1AjFYceaYtLRaoh3MweL
=Wgz7
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jul_2009_15_41_50_+1000_uKzOXmkgptQLYFdS--

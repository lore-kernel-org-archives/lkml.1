Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbZJFC3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbZJFC3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 22:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbZJFC3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 22:29:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34382 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731AbZJFC3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 22:29:44 -0400
Date: Tue, 6 Oct 2009 13:28:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20091006132857.5bd1cc3a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_Oct_2009_13_28_57_+1100_rdZ=MCLIcAsQuAor"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Oct_2009_13_28_57_+1100_rdZ=MCLIcAsQuAor
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/radeon/radeon_device.c between commit
28d520433b6375740990ab99d69b0d0067fd656b ("drm/vgaarb: add VGA
arbitration support to the drm and kms") from Linus' tree and commit
62a8ea3f7bb61e5f92db0a648b7cc566852c36ec ("drm/radeon/kms: Remove old
init path as no hw use it anymore") from the drm tree.

I have no idea how to reconcile these, so I have just used the version
from the drm tree.  Please do the merge with Linus' tree and fix this up
properly.  (There are also still conflicts in
drivers/gpu/drm/radeon/radeon.h and drivers/gpu/drm/radeon/radeon_asic.h)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Oct_2009_13_28_57_+1100_rdZ=MCLIcAsQuAor
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrKq2kACgkQjjKRsyhoI8wybgCfVuJA/yLfb7HIzh5sZ2FReO8+
SQ8AoJZYQiYqP2sir/Bj7bd+s0QCPmlB
=Hu2B
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Oct_2009_13_28_57_+1100_rdZ=MCLIcAsQuAor--

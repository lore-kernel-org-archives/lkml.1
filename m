Return-Path: <linux-kernel-owner+w=401wt.eu-S1751387AbZKSFYC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbZKSFYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 00:24:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZKSFYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 00:24:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43502 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZKSFXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 00:23:55 -0500
Date: Thu, 19 Nov 2009 16:23:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the edac-amd tree with the rr tree
Message-Id: <20091119162354.8800a885.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__19_Nov_2009_16_23_54_+1100_xoscuZ6UPGTj1kKT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Nov_2009_16_23_54_+1100_xoscuZ6UPGTj1kKT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Borislav,

Today's linux-next merge of the edac-amd tree got a conflict in
drivers/edac/amd64_edac.c because commit
4de1ce0c99ff838090d3b57cab8bc6eeb303dda5
("cpumask:amd64_edac-cpumask_t-remove") from the rr tree and commit
2fd9af91b92c10e58993f9eb70300fdff32698fb ("cpumask: use modern cpumask
style in drivers/edac/amd64_edac.c") from the edac-amd tree are the same
patch but there are further changes in the edac-amd tree.  So, Rusty, I
guess you can drop that patch (unless something later in the rr tree
depends on it).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__19_Nov_2009_16_23_54_+1100_xoscuZ6UPGTj1kKT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksE1moACgkQjjKRsyhoI8zPYgCgvmcEcFtihHfkah+1+NbK/8H0
yeIAnRZsApgrQPVp3Q5GgWTgzk465eLe
=tztr
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Nov_2009_16_23_54_+1100_xoscuZ6UPGTj1kKT--

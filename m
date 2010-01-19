Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932Ab0ASG1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0ASG1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 01:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581Ab0ASG1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 01:27:50 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35697 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab0ASG1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 01:27:49 -0500
Date: Tue, 19 Jan 2010 17:27:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: linux-next: driver-core tree build warning
Message-Id: <20100119172741.2dd81553.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Jan_2010_17_27_41_+1100_fOEGlXJJyDT2fkLe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Jan_2010_17_27_41_+1100_fOEGlXJJyDT2fkLe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

drivers/base/cpu.c:264: warning: initialization from incompatible pointer t=
ype
drivers/base/cpu.c:265: warning: initialization from incompatible pointer t=
ype

Introduced by commit 380567d3dc35a62f5cc0ec640a45dfc238238417 ("sysdev:
Convert node driver")?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_Jan_2010_17_27_41_+1100_fOEGlXJJyDT2fkLe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktVUN0ACgkQjjKRsyhoI8xx9ACePjclVs4vlZ4kDxN0BphEJ56V
b3IAoI+3QtOQSKZUOWq+szNlBM0Nqdiy
=ovbY
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Jan_2010_17_27_41_+1100_fOEGlXJJyDT2fkLe--

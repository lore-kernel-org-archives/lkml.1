Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab0BKGK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 01:10:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60393 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab0BKGKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 01:10:25 -0500
Date: Thu, 11 Feb 2010 17:10:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: build warning after merge of the suspend tree
Message-Id: <20100211171018.1011199f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Feb_2010_17_10_18_+1100_qT1+Ygtuju85nvo1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Feb_2010_17_10_18_+1100_qT1+Ygtuju85nvo1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the suspend tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/usb/core/hcd-pci.c:138: warning: 'wait_for_companions' defined but =
not used

Introduced by commit ce74abf51a15ab82a9fae6dcd8a9c0038945f10e ("USB:
implement non-tree resume ordering constraints for PCI host controllers").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Feb_2010_17_10_18_+1100_qT1+Ygtuju85nvo1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktzn0oACgkQjjKRsyhoI8xuUwCeOg8r4cs/rN+BcmEc2XX4p2WM
lX4An1QbINd3PgRMYBZL72KXABgjRZAT
=46Ou
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Feb_2010_17_10_18_+1100_qT1+Ygtuju85nvo1--

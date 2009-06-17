Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbZFQG0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbZFQG0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 02:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbZFQG0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 02:26:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43973 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbZFQG0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 02:26:15 -0400
Date: Wed, 17 Jun 2009 16:26:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: arm build failures
Message-Id: <20090617162612.703adfd9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Jun_2009_16_26_12_+1000_TA_6K4hWtFlEHcya"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Jun_2009_16_26_12_+1000_TA_6K4hWtFlEHcya
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

Over the past few days, I have started getting some arm configs (at least
iop13xx_defconfig and integrator_defconfig, but some others) failing to
build getting this error:

  SYSMAP  System.map
  SYSMAP  .tmp_System.map
Inconsistent kallsyms data
Try setting CONFIG_KALLSYMS_EXTRA_PASS

Is this something you have seen?  Could it be my toolchain (I am
currently using gcc 4.4.0 and have not changed it recently)?

I first saw this with next-20090615 i.e. Monday's tree.  Some configs
seem to have recovered, but others only hit it yesterday and some have
not hit it at all.  See http://kisskb.ellerman.id.au/kisskb/branch/9/
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Jun_2009_16_26_12_+1000_TA_6K4hWtFlEHcya
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko4jIQACgkQjjKRsyhoI8xngwCgq7Edcdum8266m6BpmAAdbb7M
67kAn2rU4VFVARVw1D3S4RP24UHiDOOl
=+6En
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Jun_2009_16_26_12_+1000_TA_6K4hWtFlEHcya--

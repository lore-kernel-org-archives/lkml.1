Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbYDSNTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbYDSNTj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 09:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbYDSNT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 09:19:29 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:36450 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347AbYDSNT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 09:19:29 -0400
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Apr 2008 09:19:28 EDT
Date: Sat, 19 Apr 2008 14:49:23 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: [2.6.25 REGRESSION] Lenovo 3000 N100 does not wake up from ACPI S3
 state
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Message-id: <4809EA53.2010404@archlinux.org>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enig4BF9DE42EB039F5CF2DD6200
X-IronPort-AV: E=Sophos;i="4.25,682,1199660400";
 d="asc'?scan'208";a="39742145"
X-Enigmail-Version: 0.95.6
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4BF9DE42EB039F5CF2DD6200
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Since 2.6.25-rc9, my Lenovo 3000 N100 (Core 2 Duo T5300), running x86_64 =

does not wake up from ACPI S3 (Suspend to RAM) any more. The display=20
remains dark.

Fix: Revert=20
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dco=
mmitdiff;h=3D783e391b7b5b273cd20856d8f6f4878da8ec31b3
Bugzilla: http://bugzilla.kernel.org/show_bug.cgi?id=3D10482



--------------enig4BF9DE42EB039F5CF2DD6200
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkgJ6lMACgkQEda5KzHP/VAutQCfVoUvv4S2sF6+s6UcJhK2ggPh
zg4AnjhrgZs2tUFBNDUoq1qLfxOSnsOe
=aMFm
-----END PGP SIGNATURE-----

--------------enig4BF9DE42EB039F5CF2DD6200--

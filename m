Return-Path: <linux-kernel-owner+w=401wt.eu-S1762363AbXITIe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762363AbXITIe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761721AbXITIdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:33:06 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:64720 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760598AbXITIdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:33:04 -0400
X-Greylist: delayed 1826 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2007 04:33:04 EDT
Date: Thu, 20 Sep 2007 10:05:35 +0200
From: Peter Schwabe <schwabe@ti.rwth-aachen.de>
Subject: Another Hitachi Disk with NCQ problems
To: linux-kernel@vger.kernel.org
Message-id: <46F229CF.5020109@ti.rwth-aachen.de>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary=------------enigD7A54DADF0B96333C90312BE
X-IronPort-AV: E=Sophos;i="4.20,277,1186351200";
 d="asc'?scan'208";a="14944565"
X-Enigmail-Version: 0.94.2.0
User-Agent: Icedove 1.5.0.12 (X11/20070731)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD7A54DADF0B96333C90312BE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

in my Thinkpad T61 there is another Hitachi harddisk with NCQ problems
(spurious completions during NCQ...).

Model number: HITACHI HTS541612J9SA00
Serial number: SBDIC7JP

Adding the line

{ "HITACHI HTS541612J9SA00", "SBDIC7JP", ATA_HORKAGE_NONCQ, },

to the ata_device_blacklist in libata-core.c fixes the problem for me.

Cheers,

Peter



--------------enigD7A54DADF0B96333C90312BE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG8inWKIi5kL3Gj1wRAlUqAJ9djgdxqoM6ZOoejqRi90728mUGzwCeNZmq
Bk/BAoap6SMpZYozNAnw5XA=
=BpqO
-----END PGP SIGNATURE-----

--------------enigD7A54DADF0B96333C90312BE--

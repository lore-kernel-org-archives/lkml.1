Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbZLNBUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbZLNBUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 20:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZLNBUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 20:20:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34232 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbZLNBUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 20:20:20 -0500
Date: Mon, 14 Dec 2009 12:20:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: linux-next: acpi tree build failure
Message-Id: <20091214122013.a869739e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Dec_2009_12_20_13_+1100_2db=b=+TwhNPFekP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Dec_2009_12_20_13_+1100_2db=b=+TwhNPFekP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next build (x86_64 allmodconfig) failed like this:

ERROR: "pnpacpi_protocol" [drivers/char/ipmi/ipmi_si.ko] undefined!

Caused by commit e80b594fd69039387339e75b4f75c58da74676ae ("PNP: add
interface to retrieve ACPI device from a PNPACPI device").

I have used the acpi tree form next-20091211 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Dec_2009_12_20_13_+1100_2db=b=+TwhNPFekP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkslks0ACgkQjjKRsyhoI8wTRgCfRnBD3mJs0m3enkd7dFb3rYvl
1Q4AnjsqcXQgleGGLjrcszXZQFhfgzlY
=x/pE
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Dec_2009_12_20_13_+1100_2db=b=+TwhNPFekP--

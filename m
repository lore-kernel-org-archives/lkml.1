Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYGNAcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYGNAcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 20:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYGNAck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 20:32:40 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51184 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343AbYGNAck (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 20:32:40 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Shaohua Li <shaohua.li@intel.com>
cc: linux-kernel@vger.kernel.org
Subject: [mmotm] pm-acpi-hibernation-utilize-hardware-signature.patch causes build error
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215938644_19658P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 13 Jul 2008 04:44:04 -0400
Message-ID: <38256.1215938644@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1215938644_19658P
Content-Type: text/plain; charset=us-ascii

Patch pm-acpi-hibernation-utilize-hardware-signature.patch in the 07/11 mmotm
causes a link error:

  LD      .tmp_vmlinux1
arch/x86/kernel/built-in.o: In function `acpi_sleep_setup':
sleep.c:(.init.text+0x6854): undefined reference to `acpi_no_s4_hw_signature'

Not at all surprising, since the patch doesn't actually include a body
for the function, only references.  Did a (hopefully) previous patch that
added the body get lost along the way?

--==_Exmh_1215938644_19658P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIecBUcC3lWbTT17ARAqedAJ9P+VsI+f9VguJ1/zW8UhgVwO5/7gCguEKW
Og6Xf2lE2EtITaw4ApxWCLE=
=NVRR
-----END PGP SIGNATURE-----

--==_Exmh_1215938644_19658P--

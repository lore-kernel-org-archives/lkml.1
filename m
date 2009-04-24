Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbZDXCq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbZDXCq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 22:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbZDXCpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 22:45:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:21165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbZDXCpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 22:45:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,238,1239001200"; 
   d="asc'?scan'208";a="509490975"
Subject: [PATCH 4/4] PCI: PCIE AER: Document for PCIE AER software error
 injection
From: Huang Ying <ying.huang@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FFCyloB5OGPBJfKhw3Uu"
Date: Fri, 24 Apr 2009 10:45:31 +0800
Message-Id: <1240541131.6842.682.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FFCyloB5OGPBJfKhw3Uu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This patch add a minimal HOWTO for PCIE AER software error injection
in Documentation/PCI/pcieaer-howto.txt.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 Documentation/PCI/pcieaer-howto.txt |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/Documentation/PCI/pcieaer-howto.txt
+++ b/Documentation/PCI/pcieaer-howto.txt
@@ -246,3 +246,24 @@ with the PCI Express AER Root driver?
 A: It could call the helper functions to enable AER in devices and
 cleanup uncorrectable status register. Pls. refer to section 3.3.
=20
+
+4. Software error injection
+
+Debugging PCIE AER error recovery code is quite difficult because it
+is hard to trigger real hardware errors. Software based error
+injection can be used to fake various kinds of PCIE errors.
+
+First you should enable PCIE AER software error injection in kernel
+configuration, that is, following item should be in your .config.
+
+CONFIG_PCIEAER_INJECT=3Dy or CONFIG_PCIEAER_INJECT=3Dm
+
+After reboot with new kernel or insert the module, a device file named
+/dev/aer_inject should be created.
+
+Then, you need a user space tool named aer-inject, which can be gotten
+from:
+    http://www.kernel.org/pub/linux/kernel/people/yhuang/
+
+More information about aer-inject can be found in the document comes
+with its source code.


--=-FFCyloB5OGPBJfKhw3Uu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknxJ8kACgkQKhFGF+eHlphYFwCfYKMytsDCUPQXo/3Zi1mRrxMY
cioAnRuIj8RzV8bxkRooWP1bVPjlBouz
=zEU8
-----END PGP SIGNATURE-----

--=-FFCyloB5OGPBJfKhw3Uu--


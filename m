Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbZKZCWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbZKZCWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 21:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZKZCWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 21:22:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48617 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbZKZCWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 21:22:33 -0500
Date: Thu, 26 Nov 2009 13:22:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Lin Ming <ming.m.lin@intel.com>, Bob Moore <robert.moore@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: linux-next: manual merge of the acpi tree with the pci tree
Message-Id: <20091126132228.85a63dee.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_Nov_2009_13_22_28_+1100_Cs5qTllUSoBF7ZAK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Nov_2009_13_22_28_+1100_Cs5qTllUSoBF7ZAK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the acpi tree got a conflict in
drivers/pci/hotplug/acpiphp_glue.c between commit
204d49a5613a06eb2fa5c3b842a29b1336cc7995 ("PCI hotplug: move IOAPIC
support from acpiphp to ioapic driver") from the pci tree and commit
2263576cfc6e8f6ab038126c3254404b9fcb1c33 ("ACPICA: Add post-order
callback to acpi_walk_namespace") from the acpi tree.

The former moved part of the code modified by the latter into another
file.  All the calls to acpi_walk_namespace() seem to have been removed
in this process.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__26_Nov_2009_13_22_28_+1100_Cs5qTllUSoBF7ZAK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEARECAAYFAksN5mQACgkQjjKRsyhoI8xoggCeL/udiBiXy3SyGBowWqQ3IZbI
ijYAljn0WNVzNIAUmy2a0Y90xwvysu8=
=bjSp
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Nov_2009_13_22_28_+1100_Cs5qTllUSoBF7ZAK--

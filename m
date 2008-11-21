Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYKUHPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYKUHPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 02:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbYKUHOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 02:14:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54798 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbYKUHOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 02:14:43 -0500
Date: Fri, 21 Nov 2008 18:14:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: greg@kroah.com, linux-pci@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de, kkeil@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: CONFIG_PCI_LEGACY removal
Message-Id: <20081121181426.9f5efa36.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__21_Nov_2008_18_14_26_+1100_0efelnCrH5LZc0sP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Nov_2008_18_14_26_+1100_0efelnCrH5LZc0sP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Now that it is more than a year since CONFIG_PCI_LEGACY was added (Oct
2007) and longer since pci_find_slot() (May 2007) and pci_find_device()
(Nov 2006) were deprecated, is there any way that we can get rid of the
last vestiges of them?

Users of pci_find_device():

drivers/isdn/hisax/avm_pci.c
drivers/isdn/hisax/bkm_a4t.c
drivers/isdn/hisax/bkm_a8.c
drivers/isdn/hisax/diva.c
drivers/isdn/hisax/elsa.c
drivers/isdn/hisax/enternow_pci.c
drivers/isdn/hisax/gazel.c
drivers/isdn/hisax/hfc_pci.c
drivers/isdn/hisax/niccy.c
drivers/isdn/hisax/nj_s.c
drivers/isdn/hisax/nj_u.c
drivers/isdn/hisax/sedlbauer.c
drivers/isdn/hisax/telespci.c
drivers/isdn/hisax/w6692.c

User of pci_find_slot():

drivers/pci/hotplug/cpqphp_pci.c

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__21_Nov_2008_18_14_26_+1100_0efelnCrH5LZc0sP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkmX9IACgkQjjKRsyhoI8z3fQCeIPz1BlFH/mlz46/eGBMUU+Lx
NEAAoKQhjXMdV5swMIT63lHHrnNXSiZB
=yD6Y
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Nov_2008_18_14_26_+1100_0efelnCrH5LZc0sP--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbZHMCrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbZHMCrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 22:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbZHMCrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 22:47:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49601 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbZHMCrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 22:47:40 -0400
Date: Thu, 13 Aug 2009 12:47:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>,
       Dave Airlie <airlied@redhat.com>
Subject: linux-next: pci tree build warning
Message-Id: <20090813124732.f29fd5c3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Aug_2009_12_47_32_+1000_WT+Ht0aizecglf9+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Aug_2009_12_47_32_+1000_WT+Ht0aizecglf9+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

Today's linux-next build (x86_64 allmodconfig) produced these warnings:

drivers/gpu/vga/vgaarb.c: In function 'vga_arb_write':
drivers/gpu/vga/vgaarb.c:834: warning: cast from pointer to integer of diff=
erent size
drivers/gpu/vga/vgaarb.c:870: warning: cast from pointer to integer of diff=
erent size
drivers/gpu/vga/vgaarb.c:920: warning: cast from pointer to integer of diff=
erent size
drivers/gpu/vga/vgaarb.c:963: warning: cast from pointer to integer of diff=
erent size
drivers/gpu/vga/vgaarb.c:1017: warning: cast from pointer to integer of dif=
ferent size

Introduced by commit a49c9c1b728fa8f50816d96a0f135e15a359e448 ("PCI/GPU:
implement VGA arbitration on Linux").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Aug_2009_12_47_32_+1000_WT+Ht0aizecglf9+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqDfsQACgkQjjKRsyhoI8yUBgCfQtbu6qjs1w3H4QJrLq8NOemb
MUoAoKDuppPdG6nuWt5bYYEhWRSwXie+
=zb4a
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Aug_2009_12_47_32_+1000_WT+Ht0aizecglf9+--

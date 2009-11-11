Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZKKIaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZKKIaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbZKKIaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:30:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39883 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534AbZKKIaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:30:12 -0500
Date: Wed, 11 Nov 2009 19:30:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Felipe Balbi <felipe.balbi@nokia.com>, Tony Lindgren <tony@atomide.com>,
       <linux-omap@vger.kernel.org>
Subject: linux-next: manual merge of the usb tree with the omap tree
Message-Id: <20091111193013.9a4bca3e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Nov_2009_19_30_13_+1100_IYRf/tMhfUe8qTga"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Nov_2009_19_30_13_+1100_IYRf/tMhfUe8qTga
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/host/ehci-omap.c between commit
7cb07f72711d3e10763ca7d7a9fcd7ac788aabf4 ("omap: ehci: Add platform init
code") from the omap tree and commit
9e92239693d7010d2e710a445f46d6a738b09171 ("USB: host: ehci: introduce
omap ehci-hcd driver") from the usb tree.

Both commits create this file but I used the omap tree version because
commit ce491cf85466c3377228c5a852ea627ec5136956 ("omap: headers: Move
remaining headers from include/mach to include/plat") from the omap tree
moved one included header file (mach/usb.h -> plat/usb.h).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_Nov_2009_19_30_13_+1100_IYRf/tMhfUe8qTga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr6dhUACgkQjjKRsyhoI8y2HACePvALDSAaw98WcGAOvILL7Yy7
lzYAoIz9mHBive5w48qeS8O9Twt1/cMK
=jVaI
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Nov_2009_19_30_13_+1100_IYRf/tMhfUe8qTga--

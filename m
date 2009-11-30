Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZK3GB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZK3GB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 01:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbZK3GB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 01:01:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51600 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbZK3GBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 01:01:25 -0500
Date: Mon, 30 Nov 2009 17:01:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: usb tree build warning
Message-Id: <20091130170128.db346120.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__30_Nov_2009_17_01_28_+1100_AdvViXo9aU/k_MV6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_Nov_2009_17_01_28_+1100_AdvViXo9aU/k_MV6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/net/wimax/i2400m/usb.c: In function 'i2400mu_suspend':
drivers/net/wimax/i2400m/usb.c:595: warning: unused variable 'usb_dev'

Introduced by commit a85c653a3945350875611d3cb071a0143cfeb2d2 ("USB:
remove the auto_pm flag") which removed the last usage in this function.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__30_Nov_2009_17_01_28_+1100_AdvViXo9aU/k_MV6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksTX7gACgkQjjKRsyhoI8xWuACfUSmf6xGfSqRbrlyXWNtiKhux
eYUAoKershDTtUadLidv7GdpScwOrndo
=djQj
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Nov_2009_17_01_28_+1100_AdvViXo9aU/k_MV6--

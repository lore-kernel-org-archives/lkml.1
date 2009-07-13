Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbZGMBil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbZGMBil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 21:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZGMBie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 21:38:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32903 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbZGMBid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 21:38:33 -0400
Date: Mon, 13 Jul 2009 11:38:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: usb.current tree build warnings
Message-Id: <20090713113826.073e7bb4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__13_Jul_2009_11_38_26_+1000_1Ra_jO=LFoghrlaT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Jul_2009_11_38_26_+1000_1Ra_jO=LFoghrlaT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/usb/serial/option.c: In function 'option_instat_callback':
drivers/usb/serial/option.c:834: warning: unused variable 'serial'
drivers/usb/serial/option.c: In function 'option_open':
drivers/usb/serial/option.c:930: warning: unused variable 'serial'

Introduced by commit d9860b9ea060492b9ce239c6317f65db1d96ffb9 ("USB:
option: remove unnecessary and erroneous code").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__13_Jul_2009_11_38_26_+1000_1Ra_jO=LFoghrlaT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpakBIACgkQjjKRsyhoI8z3xQCfa7Db/hS58NsFNWGyzrElgeKU
RKcAnAqkiy6l9uasZx5YKSyUPxfN6Nqg
=hTQy
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Jul_2009_11_38_26_+1000_1Ra_jO=LFoghrlaT--

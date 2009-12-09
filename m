Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZLIF4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZLIF4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZLIF4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:56:46 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38341 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbZLIF4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:56:45 -0500
Date: Wed, 9 Dec 2009 16:56:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: staging tree build failure
Message-Id: <20091209165646.41b9ce8a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Dec_2009_16_56_46_+1100_5QP5zI3ZS5/QwUvd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Dec_2009_16_56_46_+1100_5QP5zI3ZS5/QwUvd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/net/usb/kaweth.c: In function 'kaweth_open':
drivers/net/usb/kaweth.c:719: error: implicit declaration of function 'usb_=
autopm_enable'

Caused by commit b3f937e6ddf3e60ed9b4c26349b7b171dffdd010 ("USB: prepare
for changover to Runtime PM framework").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Dec_2009_16_56_46_+1100_5QP5zI3ZS5/QwUvd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksfPB4ACgkQjjKRsyhoI8zBHQCgj4mBPNx8aH5MRFmZDonLlmqa
OOEAmwQOVrU42FHRlIFLylCnJ8hffygC
=1QoI
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Dec_2009_16_56_46_+1100_5QP5zI3ZS5/QwUvd--

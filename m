Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbZD2EuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbZD2EuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 00:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZD2Ety
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:49:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53897 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbZD2Etx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:49:53 -0400
Date: Wed, 29 Apr 2009 14:49:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: origin tree build warning
Message-Id: <20090429144947.5d308d3e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Apr_2009_14_49_47_+1000_BA0/ll41q+4cdkNl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Apr_2009_14_49_47_+1000_BA0/ll41q+4cdkNl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/media/radio/radio-si470x.c: In function 'si470x_fops_release':
drivers/media/radio/radio-si470x.c:1217: warning: label 'unlock' defined bu=
t not used

Caused by commit ec5f5bf80501abfe2da2897cfcde8452b545aacb ("radio_si470x:
Fix free memory corruption") which removed the last reference to this
label.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Apr_2009_14_49_47_+1000_BA0/ll41q+4cdkNl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn33GsACgkQjjKRsyhoI8w/7QCfdZ4tO5LB17QxHtdqklVIQr3e
h7QAn1nW16OjoLJptM3GPOinWMJm/06g
=kVP6
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Apr_2009_14_49_47_+1000_BA0/ll41q+4cdkNl--

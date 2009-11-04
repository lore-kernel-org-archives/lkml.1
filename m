Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZKDCPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZKDCPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbZKDCPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:15:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53156 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbZKDCPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:15:44 -0500
Date: Wed, 4 Nov 2009 13:15:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-usb@vger.kernel.org
Subject: linux-next: pcmcia tree build failure
Message-Id: <20091104131540.f39af556.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__4_Nov_2009_13_15_40_+1100_6pxCgNBd+MeBMsVq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Nov_2009_13_15_40_+1100_6pxCgNBd+MeBMsVq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dominik,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/telephony/ixj_pcmcia.c: In function 'ixj_probe':
drivers/telephony/ixj_pcmcia.c:35: error: 'link' undeclared (first use in t=
his function)

Caused by commit 990c0c8eeb34f62d062052d462feaa99715cb043 ("pcmcia: use
dynamic debug infrastructure, deprecate CS_CHECK (misc drivers)").

I have used the version of the pcmcia tree from next-20091102 for today.
Please build test.  :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__4_Nov_2009_13_15_40_+1100_6pxCgNBd+MeBMsVq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrw48wACgkQjjKRsyhoI8wo+ACdGiea9nS6Z8lDTpWOCGCREpxh
4hMAnRSNpLE80hZN2xgDwvZUfLSRonwp
=H7Tk
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Nov_2009_13_15_40_+1100_6pxCgNBd+MeBMsVq--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbZICFwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbZICFwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 01:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbZICFwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 01:52:02 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49090 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328AbZICFwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 01:52:01 -0400
Date: Thu, 3 Sep 2009 15:51:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: linux-next: security-testing tree build failure
Message-Id: <20090903155154.fb1e8624.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Sep_2009_15_51_54_+1000_WnJy+q./kenveHpT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Sep_2009_15_51_54_+1000_WnJy+q./kenveHpT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

kernel/cred.c: In function 'cred_alloc_blank':
kernel/cred.c:234: error: void value not ignored as it ought to be

Caused by commit ee18d64c1f632043a02e6f5ba5e045bb26a5465f ("KEYS: Add a
keyctl to install a process's session keyring on its parent [try #6]").

I have used the version from next-20090902 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Sep_2009_15_51_54_+1000_WnJy+q./kenveHpT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqfWXoACgkQjjKRsyhoI8xC5QCdF1dcGjmJvmbmMH8ehOUMh+HB
hckAoIOwV7srlMBcGx30eaZongRrJrR+
=DQaK
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Sep_2009_15_51_54_+1000_WnJy+q./kenveHpT--

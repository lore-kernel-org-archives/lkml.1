Return-Path: <linux-kernel-owner+w=401wt.eu-S1751788AbZJHEbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbZJHEbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 00:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZJHEbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 00:31:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57219 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbZJHEbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 00:31:35 -0400
Date: Thu, 8 Oct 2009 15:30:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: linux-next: suspend tree build failure
Message-Id: <20091008153051.37f043fa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__8_Oct_2009_15_30_51_+1100_o0TxhI25Q0XA2XZm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Oct_2009_15_30_51_+1100_o0TxhI25Q0XA2XZm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next build (powerpc allyesconfig) failed like this:

kernel/power/process.c: In function 'try_to_freeze_tasks':
kernel/power/process.c:72: error: implicit declaration of function 'msleep'

Caused by commit a48145a7cbf3b0555ba3ad61aaf2c38719bab95d ("PM / freezer:
Don't get over-anxious while waiting") which I have reverted for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__8_Oct_2009_15_30_51_+1100_o0TxhI25Q0XA2XZm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrNavsACgkQjjKRsyhoI8xrYACfUuFruYf0aeTT3/w6twH4bI+I
oEoAnR/K7ATthr65WuRrculCzujAWCst
=Wnyx
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Oct_2009_15_30_51_+1100_o0TxhI25Q0XA2XZm--

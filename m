Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0CIScW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:32:22 -0500
Received: from mail.klingt.org ([86.59.21.178]:44664 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab0CIScQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:32:16 -0500
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 13:32:16 EST
From: Tim Blechmann <tim@klingt.org>
To: linux-kernel@vger.kernel.org
Subject: [perf] perf report output not decoded
Date: Tue, 9 Mar 2010 19:22:46 +0100
User-Agent: KMail/1.13.1 (Linux/2.6.33; KDE/4.4.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3199180.hyUmDSN6EL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201003091922.49208.tim@klingt.org>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Tue, 09 Mar 2010 19:22:50 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3199180.hyUmDSN6EL
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

hi ingo & others,

it seems, that with 2.6.33, the perf report cannot correctly decode symbols
from user-space objects:

# Samples: 211435499487
#
# Overhead  Command      Shared Object  Symbol
# ........  .......  .................  ......
#
    99.78%   :16956         378283e010  0x000000378283e010 ! [.] 0x00003782=
83e010


perf top decodes the specific shared object correctly. is this a known issu=
e?
i'm experiencing this on an x86-64 nehalem machine.

thanks, tim

=2D-=20
tim@klingt.org
http://tim.klingt.org

Who need fossil fuel when the sun ain't goin' nowhere
  Amiri Baraka

--nextPart3199180.hyUmDSN6EL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkuWkfYACgkQg0On+TFEWzwGRQCghOICTE5B9IwfPdZxcCGec2Ax
tFQAmweSf86oTd6CBMniQrB7j7edSiid
=mq6b
-----END PGP SIGNATURE-----

--nextPart3199180.hyUmDSN6EL--

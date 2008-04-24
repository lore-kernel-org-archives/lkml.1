Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbYDXIpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbYDXIpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 04:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYDXIpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 04:45:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:5106 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbYDXIpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 04:45:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:message-id;
        b=V/Lj2IExsQqQjnfj4eHQ9l2wik4Md/KZ0OmmXNc4OZoCoO+NCmghXDGKiy9lAtNgoYHRL3L8aa+lAbKYAaI8aRN/GPjKXXSwwREMwluI2i471fsuTLES9wF3WYXNoEpLi6HIRJu8dK6KB1zaBlg9lvkvyPCon8X3D5j9EYetvuk=
From: Daniel Klaffenbach <danielklaffenbach@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 regression: powertop says 120K wakeups/sec
Date: Thu, 24 Apr 2008 10:51:41 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart32680566.YjRAuR9tpX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804241051.47830.danielklaffenbach@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart32680566.YjRAuR9tpX
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

With the stable 2.6.25 release I still get a _massive_ amount of wakeups=20
(around 50k). Also the power consumption is a lot higher than with 2.6.24.5=
=2E=20
I am using a Mobile AMD Sempron (32bit) on an nx6125 laptop (Gentoo).
In 2.6.25 an "extra timer interrupt" appeared, which was not there in previ=
ous=20
kernel versions.

Power usage:
2.6.24.5: ~12-15 W
2.6.25: ~16-22 W

Wakeups:
2.6.24.5: 10-300
2.6.25: 900-50000!!


I thought the patch posted went into the stable kernel, but it does not see=
m=20
to do anything for me. I have also tried 2.6.25-git3, but no changes.

Here are some links to potentially useful files (idle, no WLAN):
dmesg-2.6.25: http://pastebin.ca/995545
powertop 2.6.25: http://pastebin.ca/995548
dmesg-2.6.24.5: http://pastebin.ca/995549
powertop 2.6.24.5: http://pastebin.ca/995550

If there is anything I can provide you with for debugging let me know.

=2D Daniel

--nextPart32680566.YjRAuR9tpX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBIEEojM8RD99ZskA8RAuFlAJ4nZAgvo2mv+IIAAPS1K4TpJWyaMwCg0d1T
ywkkWLHMX8no8DN2VgJVlec=
=4EAf
-----END PGP SIGNATURE-----

--nextPart32680566.YjRAuR9tpX--

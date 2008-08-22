Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbYHVQxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbYHVQxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYHVQxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:53:14 -0400
Received: from mx40.mail.ru ([194.67.23.36]:61593 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbYHVQxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:53:13 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-usb@vger.kernel.org
Subject: Re: 2.6.27-rc4: 90% system time because of khubd, unable to reboot
Date: Fri, 22 Aug 2008 20:53:03 +0400
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200808222026.25944.arvidjaar@mail.ru>
In-Reply-To: <200808222026.25944.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1283358.9t4frlYNq4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808222053.09066.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1283358.9t4frlYNq4
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 22 August 2008, Andrey Borzenkov wrote:
>=20
> 2.6.26-rc3 is OK
>=20
> top - 20:11:08 up 5 min,  1 user,  load average: 7.05, 4.50, 1.93
> Tasks: 103 total,   3 running, 100 sleeping,   0 stopped,   0 zombie
> Cpu(s):  8.3%us, 91.7%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0=
=2E0%st
> Mem:    494172k total,   278192k used,   215980k free,    18264k buffers
> Swap:   500432k total,        0k used,   500432k free,   159376k cached
>=20
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>   851 root      15  -5     0    0    0 R 65.6  0.0   3:21.16 khubd

reverting 38b375d9610e2467cb793a84d17c6f65e44cdb39 fixed it

--nextPart1283358.9t4frlYNq4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiu7vAACgkQR6LMutpd94w8nQCfejdIt2gqqq1yYsk1oOimFE1k
jXsAn1bGbQFUH5SvYPS/n1U39SH+7euB
=8oA+
-----END PGP SIGNATURE-----

--nextPart1283358.9t4frlYNq4--

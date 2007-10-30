Return-Path: <linux-kernel-owner+w=401wt.eu-S1760214AbXJ3Tee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214AbXJ3Tee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbXJ3Tdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:33:36 -0400
Received: from mx40.mail.ru ([194.67.23.36]:55488 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760282AbXJ3Tdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:33:35 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24: (ACPI AC adapter) sending {proc,netlink,kobject}_event from -> resume method?
Date: Tue, 30 Oct 2007 22:33:30 +0300
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2335885.T9XvSHH5Ht";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710302233.31791.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2335885.T9XvSHH5Ht
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Is it valid to send events from within ->resume device method? If not, what=
 is=20
the proper way to notify user space about hardware changes during suspensio=
n?=20
Specifically it seems that new sysfs ACPI power supply interface sometimes=
=20
missing plugged in AC cord during suspend. I suspect that no event is=20
generated for this; I am not sure whether ACPI is required to generate such=
=20
events at all in this case.

I'll need some time to get reproducible case so I do not categorize this ye=
t=20
as regression.

=2Dandrey

--nextPart2335885.T9XvSHH5Ht
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJ4cLR6LMutpd94wRAmgkAKC4x7oyGD4MC7JxirA686r9K9TAdACgo4OX
PFwOpEHZ4Ix5L0opsoflI7U=
=Qf0i
-----END PGP SIGNATURE-----

--nextPart2335885.T9XvSHH5Ht--

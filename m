Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbZBKTvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbZBKTvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 14:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbZBKTvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 14:51:33 -0500
Received: from mail.klingt.org ([86.59.21.178]:50289 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554AbZBKTvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 14:51:32 -0500
Message-ID: <49932C35.3020300@klingt.org>
Date: Wed, 11 Feb 2009 20:51:17 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
CC: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Subject: 2.6.29-rc4 regression (was: Re: 2.6.28-rc9: oprofile regression)
References: <1229869416.6911.1.camel@thinkpad>
In-Reply-To: <1229869416.6911.1.camel@thinkpad>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig21169FDAE48F723B085E55C1"
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Wed, 11 Feb 2009 20:51:17 +0100 (CET)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig21169FDAE48F723B085E55C1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

i am not sure, whether it is related to my problem with 2.6.28, but
running oprofile on kernel 2.6.29-rc4 (today's linus/master to be
exact), i do not get _any_ NMI:

tim@thinkpad:~$ sudo opcontrol -s
Using 2.6+ OProfile kernel interface.
Using log file /var/lib/oprofile/samples/oprofiled.log
Daemon started.
Profiler running.
tim@thinkpad:~$ cat /proc/interrupts |grep NMI
NMI:          0          0   Non-maskable interrupts
tim@thinkpad:~$ sudo opcontrol -d
tim@thinkpad:~$ cat /proc/interrupts |grep NMI
NMI:          0          0   Non-maskable interrupts

dmesg tells me:
oprofile: using NMI interrupt.

best, tim

--=20
tim@klingt.org
http://tim.klingt.org

When you open windows, bugs get in.


--------------enig21169FDAE48F723B085E55C1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmTLDcACgkQdL+4qsZfVssPVgCeIYIrnSYHZG6zA5+0T0gNh4Gl
K60An11D1/1hPIJ3fBbGTvVP8flu1tQ1
=yIpJ
-----END PGP SIGNATURE-----

--------------enig21169FDAE48F723B085E55C1--

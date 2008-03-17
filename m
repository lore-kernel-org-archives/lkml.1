Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYCQNHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYCQNHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 09:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYCQNH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 09:07:27 -0400
Received: from posthamster.phnxsoft.com ([195.227.45.4]:4630 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYCQNH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 09:07:26 -0400
Message-ID: <47DE6CC7.2000405@imap.cc>
Date: Mon, 17 Mar 2008 14:06:15 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Daniel Lezcano <dlezcano@fr.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       pekkas@netcore.fi, yoshfuji@linux-ipv6.org
Subject: Re: [2.6.25-rc5-mm1] regression: cannot run Postfix sendmail command
 as non-root
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D98510.60801@imap.cc> <47D9A8DF.30809@fr.ibm.com> <47D9C1F0.6050803@imap.cc> <47DE4B7B.9040504@fr.ibm.com>
In-Reply-To: <47DE4B7B.9040504@fr.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7B6DABE6C137B0E4DCEACF24"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7B6DABE6C137B0E4DCEACF24
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Daniel Lezcano schrieb:

> I was not able to reproduce it, but I think I didn't configured postfix=
=20
> as I should had. What version do you use ?

It's the one that comes with openSUSE 10.3:

ts@xenon:~> rpm -q postfix
postfix-2.4.5-20.2

> If I may ask you, can you put your postfix configuration file and a=20
> strace -f of your failing command ? on your website, that will help me =
a=20
> lot to investigate.

Sure, no problem. You may find them at

http://gollum.phnxsoft.com/~ts/linux/main.cf
http://gollum.phnxsoft.com/~ts/linux/strace.log

HTH
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig7B6DABE6C137B0E4DCEACF24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH3mzHQ3+did9BuFsRAnbKAJ9oHGy2VxrAEhzAE/fix4Fhx0dq4ACbB0tu
5L7z+g04FX9uxXKRm/5E0wI=
=vk8G
-----END PGP SIGNATURE-----

--------------enig7B6DABE6C137B0E4DCEACF24--

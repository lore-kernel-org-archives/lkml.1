Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYLaWed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYLaWed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbYLaWeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:34:09 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56650 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbYLaWeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:34:07 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] headers_install.pl: autoconvert asm/inline/volatile to __xxx__
Date: Wed, 31 Dec 2008 17:34:05 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <1230364498-31620-1-git-send-email-vapier@gentoo.org> <200812311815.09031.arnd@arndb.de>
In-Reply-To: <200812311815.09031.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart13264354.Vi80FdSRRB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812311734.06124.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart13264354.Vi80FdSRRB
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 31 December 2008 12:15:07 Arnd Bergmann wrote:
> On Saturday 27 December 2008, Mike Frysinger wrote:
> > Headers in userspace should be using the __xxx__ form of the asm, inlin=
e,
> > and volatile keywords. =A0Since people like to revert these things with=
out
> > realizing what's going on, have the headers install step autoconvert
> > these keywords.
> >
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> The patch looks right, but I would argue that most of the instances of
> any of these should not be exported in the first place. I'm not
> sure whether there is a legitimate use for the byteorder inlines,
> but the others I could find look like they are not meant for use by the
> kernel.

maybe, but those threads are going to take quite a while to resolve and thi=
ngs=20
will constantly leak back out.
=2Dmike

--nextPart13264354.Vi80FdSRRB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJW/NeAAoJEEFjO5/oN/WBqREP/R9TnTGRT+bT9sZmQDU1FLrq
6f4N2pSzQZe8Fu/176jc8WCesBikUMJ9IVsoOoSuzdpViChaFo+qEn8DIneNtU3u
x6n6hakIyPBp2uHjidxxRujdKqwPeCv3lOqLOWyeQBJTVAOUAi9hHPOT29Pgq+b7
8GRsjPGB3bPNMyik/bcvkOqyCroNA57t+WFGNbv6e2yEzc1AHQ5izjbVvJ1clsTY
Myrcmbxtg+Da8ei8noF1nzU8rYlTufJnjV4OrKSpcHCfhLRBIxAb3gKsppHca4G1
NqNOjEJ8161x7vq7o4LbrJFTZdrA25pxmRn02tYSMCHdBc25nkhEuhQlHvgGudRy
EXi3YylFAImaTgaFXCOAfmAs9/Zn2c7gkQm1qPmpwgbz9tIldb/WQdAcOvt2Deps
kigYr3bG4LIGff2zknNHVtBnFOWkBbXNOkftkg/XC1afKP0Q7eNSMQ0UNhunTXxG
C7A90BfO8iDewjzARgzxGV04fltZ6rFtYAJGw42wYQ9amBYUqkQdfl1ISOJ/hIr8
ZUTw5cq9tqi0QtdxNiRmWDkKSoLFxde8N6iaMYJmBQUBHD3fJZrHdhp3auEXZ/QX
bp49ydCiXHwxr/SqVxJhtCK0xl4emWFmJdcVAfR8+x2N+ZiGDMTAwQFyS8R5+nej
PCRju9mJDZJ5+pASm8KD
=Lsy8
-----END PGP SIGNATURE-----

--nextPart13264354.Vi80FdSRRB--

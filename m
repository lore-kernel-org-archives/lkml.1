Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbYL0TXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbYL0TXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 14:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYL0TXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 14:23:22 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:57090 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbYL0TXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 14:23:22 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] headers_check.pl: disallow extern's
Date: Sat, 27 Dec 2008 14:23:17 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1230363816-24097-1-git-send-email-vapier@gentoo.org> <20081227184355.GA9264@uranus.ravnborg.org>
In-Reply-To: <20081227184355.GA9264@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10896040.TkJR6dZsfH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812271423.19378.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10896040.TkJR6dZsfH
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 27 December 2008 13:43:55 Sam Ravnborg wrote:
> On Sat, Dec 27, 2008 at 02:43:36AM -0500, Mike Frysinger wrote:
> > Since prototypes with "extern" refer to kernel functions, they make no
> > sense in userspace, so reject them automatically.
>
> I do agree with this

so the next question is about using "extern" in general.  unless you have a=
=20
nice way of detecting function prototypes (i certainly dont have a magic re=
gex=20
for this that is multiline, etc...), i think we should be using "extern" at=
=20
least in every header that goes to userspace so that we can catch things.
=2Dmike

--nextPart10896040.TkJR6dZsfH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJVoCnAAoJEEFjO5/oN/WBLKoP/1heTCFRw7UFB7ddA1foNImw
Yp6YUfoipi+wEa5TzSyV7emSD+sHQXwPyPfNqoRrl4dq4jOGkKhtZL9J6iRVS06r
9JGkgtbvbZVAxRCx1S2Fkxy8Nm+SmlOAUVVUj+dCS2Xw9sYVOKq7SK93VLIs51s5
onM02cFUt7Nz81S4PX3kDopU/dBdh7yTk9St3xhKNsPzCHtYMNpDQR2wwsYqTsUx
0nHvEm6ODtGlA3CshbIlI+dIPH5MlfyxZcnBKaF/HPiuBapDvl3zFMYNccU7rCyc
VeXk2rQqGNLWRaYc4EWVgnpJCQMsYamL78kaM2gK/LzrbbA9tlKMs8PJq22i/LlI
HJW8kaZwuAbbcAnSBSzHOrUDK1O0nWQ2VlJtFD2aNXHHwnh2mqZW+/uyy87DX66C
2LP40sC2mGd6etJfQcQ5vBJttminAVkK1OhyGdbBZC64sxD/JuzhCFgJrCYmNF1q
OwHO+62y6nhUK6hAqAe0IR++uNF7a9P+1aHXO2O5jK1Era/bdhL8pbIM5phnxuTk
sOmah186dRX9lRkRzKxUFB8ZQH19zoqgpqQEwfI/+KbOcDUX+50tddMiKdTjW5bp
wWgdM9tGk0XiHQFIVhqIRzfkPicf2xSvJ1Wgb3EXy1WWVmURPsO/m8Os0+ohSuNU
4OCPzjHNA2/LlNoRpM0d
=y+ad
-----END PGP SIGNATURE-----

--nextPart10896040.TkJR6dZsfH--

Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbZACBU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbZACBU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 20:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbZACBUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 20:20:47 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:47580 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321AbZACBUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 20:20:46 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] headers_check.pl: disallow extern's
Date: Fri, 2 Jan 2009 20:20:42 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
References: <1230363816-24097-1-git-send-email-vapier@gentoo.org> <20090102160525.430c59f9@infradead.org> <200901030109.58197.arnd@arndb.de>
In-Reply-To: <200901030109.58197.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart58629053.nrv1kIuzhF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901022020.44200.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart58629053.nrv1kIuzhF
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 02 January 2009 19:09:57 Arnd Bergmann wrote:
> On Saturday 03 January 2009, Arjan van de Ven wrote:
> > in addition... what business does the kernel have to provide function
> > prototypes to userspace, other than the system call prototypes?
>
> This is the point I raised in my initial comment: we should warn about
> all of them if possible. Note that the syscalls.h file is not even
> exported. I can't think of a single case where a function protoype
> should be exported from the kernel to user space.

right, and unless people someone can come up with some magic perl code to=20
detect function prototypes, i suggest we start adding extern keywords ...
=2Dmike

--nextPart58629053.nrv1kIuzhF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJXr1sAAoJEEFjO5/oN/WBYIsP/0M7WrNlTP/uWHlFbTIwZiGf
cxJAvlJrBvYOT5uTqVhdxYsW5mUnIItT1dBB4M3crZS0V0zux2vAeXL5BnBx78XE
ltrUBT+M4kuYpfG/l9HaJN3xuAgVvpRxpH7TkmNia083HAWkJ98tlccYFZr+H5GB
OJFMc/hFiYsYdgpawo4laVrts0E8ZiONoBwqiEMh+GIs4WY/jvJ0bw3J3DvkBCmJ
IeiZ4NxbAaqGTRmsF6iMrwY+cWFaWX8FtwXo0CTJcszB9xxR31QfO0Ue5eCxFqcp
F43bKUhNUfz9jQtYs8QM6qSbAKE9/NoP2zhPluGE8vWbmsAvgf26TbvKeIbTgxtf
hdrBeVstCuR1FDW066gpzIn0yq7ZXWzow531K5UxN8HEa4zUDMOL/91/oui51vcR
LpEf6YG0ugigBgh7G3Nlh/U/VXijR+HxZ9vvMkuLF2/CbwJicIykWVJKjqLNo4us
CYpAY3Y87suOtdBTY4+JTsbn4+qJGeLUiteibQNDGuiLH5AjZ6ujqSvhbZEzjrJp
dnAmVWMfvCK5BPWJC9qxjB1ssp0vR5kuC8KtUMur14oDO19kyQpsFTV1sHJz8ThX
7g0JDV725gupy4R/8Y2CD4nCqLI17e9xnHyy8O2l2TdCIOuSaccKIvLTx86gU9LY
8g0+AquX2xE6QmT9WsoZ
=hn2b
-----END PGP SIGNATURE-----

--nextPart58629053.nrv1kIuzhF--

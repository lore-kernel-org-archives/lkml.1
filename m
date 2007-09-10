Return-Path: <linux-kernel-owner+w=401wt.eu-S1761913AbXIJX26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913AbXIJX26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 19:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbXIJX2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 19:28:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:33632 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbXIJX2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 19:28:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH 1/2] Maple Bus support for SEGA Dreamcast
Date: Mon, 10 Sep 2007 19:28:47 -0400
User-Agent: KMail/1.9.7
Cc: "Adrian McMenamin" <lkmladrian@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
References: <8b67d60709101616p7430a572w3ed0921a846805@mail.gmail.com>
In-Reply-To: <8b67d60709101616p7430a572w3ed0921a846805@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9384362.cqbl0AjOeP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709101928.48719.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9384362.cqbl0AjOeP
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 10 September 2007, Adrian McMenamin wrote:
> +config MAPLE
> +	tristate "Maple Bus Support"
> +	depends on SH_DREAMCAST
> +	help
> +	  The Maple Bus is SEGA's serial communication bus for peripherals
> +	  on the Dreamcast. Without this bus support you won't be able to
> +	  get your Dreamcast keyboard etc to work, so most users
> +	  probably want to say 'Y' here, unless you are only using the
> +	  Dreamcast with a serial line terminal or a remote network
> +	  connection.

hmm, tristate means you can build it as a module ... so please add a line t=
hat=20
says what the module name is if 'M' is selected ...

> --- a/drivers/sh/Makefile
> +++ b/drivers/sh/Makefile
> +obj-$(CONFIG_MAPLE) +=3D maple/

ok ...

> --- /dev/null
> +++ b/drivers/sh/maple/Makefile
> +obj-y	:=3D maplebus.o

erp, shouldnt that be obj-$(CONFIG_MAPLE) ?
=2Dmike

--nextPart9384362.cqbl0AjOeP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iQIVAwUARuXTMEFjO5/oN/WBAQJQwg/+KpD0gA9NLx00DBwDQtVHpKMrMkx/OGP5
z2qm/uFchNa0K7LWWXNjb17uFOYK2YzwoMNGwcv/WawQqzkait0YUIL+iD4xvv2e
9rt0eM8CGeaVO/OoAqnDj7qr8lkihwXbMoTrfumuwhYOpHdo/y+YTL7kUo1Bi2qg
GwwB0WGfuAzWGwH97zLUHwWnhX3XDajj3xzNErnRTMnYgKW0AW46q0lw1KBCcZo5
rr7+IyktlN4UqhO+ocAek/ojgDbkl1cMrPWZoLkf1erZh9SCbdJnwyTFCT+2bUUS
M7PsKO+8a5VNDmRQ1ZwbMCOFX214oH8jLnjPeEKhnRN5RG57a+SMq1ICw4IDici6
ihfkRJwc5wQzx8JxIkdWxBRtNKoP7NUoHQela9C0Ci1unfoCI5b3joVjZPrK31P/
6kQ6hBDibAiYFgcE1t6i35v4eI6xvJNbeoHp90uL9NhmoJTsXaJT+Z4qwKw9ng1g
/9PMrLrqL0uIaiN+QImvBMpB++GyWM2HQHSpYzuIHsdsYoPMr0rwUJxJie2APlIh
xoIV4lPnEHIhRXxRCmerA4BUiz1RLg7aiYvKIYwBDdidRIMz39i1LXdvUM895Muv
dQuKb5inA9NGf/7fZav1lMqwbe3rJIc9jZ5qXW9l4MlG+BmiJytP8vJaixAmZ2rY
KuNrEA7EcJU=
=pypr
-----END PGP SIGNATURE-----

--nextPart9384362.cqbl0AjOeP--

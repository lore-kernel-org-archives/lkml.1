Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbXFRIHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbXFRIHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbXFRIHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:07:24 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51823 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbXFRIHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:07:22 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch] make hdrscheck.sh force __asm__ in exported headers
Date: Mon, 18 Jun 2007 04:07:28 -0400
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <200706171854.24763.vapier@gentoo.org> <20070618075410.GC21222@uranus.ravnborg.org>
In-Reply-To: <20070618075410.GC21222@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2939643.4spZRdZeBI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706180407.29352.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2939643.4spZRdZeBI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 18 June 2007, Sam Ravnborg wrote:
> On Sun, Jun 17, 2007 at 06:54:24PM -0400, Mike Frysinger wrote:
> > This updates scripts/hdrschecks.sh by grepping for asm() constructs and
> > rejecting them in favor of __asm__() in exported headers.
>
> I have a new version of hdrcheck in works written in perl
> and a bit faster too.
> I hope to finish it off this weekend and sent it for review.
> Could I ask you to pick it up and add the below test to that version
> when it hits mainline - assuming that the other patches has hit mainline
> too. I do not want this check before we are clean so we basically use it =
to
> check that noone introduce a bug.

that's fine ... one of the other things i wanted to add were checks to make=
=20
sure the exported headers did not contain [us](8|16|32|64) references, but=
=20
there's headers which refer to these in comment blocks or use them as membe=
rs=20
of structs (like the netfilter code) so i couldnt add that check without=20
passing things through the preprocessor ... perhaps your perl code would=20
better accommodate this, perhaps not ;)
=2Dmike

--nextPart2939643.4spZRdZeBI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARnY9QUFjO5/oN/WBAQKCGxAAl7IM3FkcQQi6/3AQ5vI3HWXPnemDwe0e
4eUhmD/xUFYG0VM0LATOo2sOgwGFcFweQTxVVSPhDPz8AC7dF3JwXw6HVvm6aKr3
GqGHQ1n22W+KM6xowyJH/lKjRt/2KDZG+KMTrdEP8sp8E8ZFla5DPDJkT2QamWAg
QOnbcmvezD+GChRd3FXeyrucAEZhRmGgZVgmo+zW5jOTNGxO8w2xI90oy5ljsHg5
xXZmOBsaXGzp5xLrFerhM/3LaGYml1WRi/aiaXL6hcedyBZ/OSbiJa4ZFH4yQoiU
ubEi33U54ntTPMJdY9my4nVjfogXFoYpVnPWXGnQJbT7EmXJ1o++hPmkZriMHb9x
P3tWVANo8sTIDtICZPJh9KrWEehjZWXMI8KTIEwFyxL/R3/av0lVB+BiExObE+6C
6vgm5dAPLW1rJdJLQFWcL+s9Uz1cWdsLrjTDEb2UVMLV4iA13CSTnbSbU3gO+9PK
mDSrHI+xdYsKbxDmFEHJKWwC3RCtWDLMqo3Xt3QXeAGAaz8VkKtqtfs4/jxO8fcd
O3hCo1hftEQijO96C6TFU6Ixl2d+Sq6NK0xRsGfY9LqRYsu/8H4saxebrk/XEq3+
Vrp0XGLYMqB65hvRptlYd7qOSBhbdLuC8daffV/v0JTpZrwe9yMWGOJxFyjRC6H7
kj53cvOFLWA=
=Zwcp
-----END PGP SIGNATURE-----

--nextPart2939643.4spZRdZeBI--

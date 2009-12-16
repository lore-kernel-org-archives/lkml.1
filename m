Return-Path: <linux-kernel-owner+w=401wt.eu-S935911AbZLPXWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935911AbZLPXWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933850AbZLPXWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:22:36 -0500
Received: from ganymede.vroon.org ([195.66.242.11]:53053 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935265AbZLPXWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:22:34 -0500
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Dec 2009 18:22:34 EST
Subject: Re: [git pull] VFS stuff, part 1
From: Tony Vroon <tony@vroon.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091216230711.GN14381@ZenIV.linux.org.uk>
References: <20091216185157.GL14381@ZenIV.linux.org.uk>
	 <a4423d670912161441v12bfa53dj7cf2cca6247dd290@mail.gmail.com>
	 <1261004048.3154.2.camel@localhost>
	 <20091216230711.GN14381@ZenIV.linux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MrkKPK8KOUlxRNQyhqIN"
Date: Wed, 16 Dec 2009 23:13:14 +0000
Message-ID: <1261005194.3154.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MrkKPK8KOUlxRNQyhqIN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-12-16 at 23:07 +0000, Al Viro wrote:
> Hrm...  What about your CONFIG_TMPFS_POSIX_ACL?

That is off:
chainsaw@prometheus /cvs/linux-2.6 $ zgrep -i tmpfs /proc/config.gz=20
# CONFIG_DEVTMPFS is not set
CONFIG_TMPFS=3Dy
# CONFIG_TMPFS_POSIX_ACL is not set

>  And see if the breakage
> starts at 1c7c474c31aea6d5cb2fb35f31d9e9e91ae466b1 (make generic_acl slig=
htly
> more generic).

Do you want me to revert 1c7c474c31aea6d5cb2fb35f31d9e9e91ae466b1
locally or try linux-2.6 old enough not to have this?

Regards,
Tony V.

--=-MrkKPK8KOUlxRNQyhqIN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEABECAAYFAkspaYoACgkQp5vW4rUFj5rSNQCdEj5ypYaDIoYUqVDrcGXeVy4E
P8YAni+oKnFO5egUXUs/Cui+sux8Md8I
=jzo5
-----END PGP SIGNATURE-----

--=-MrkKPK8KOUlxRNQyhqIN--


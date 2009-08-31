Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZHaSnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZHaSnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbZHaSnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:43:51 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:33452
	"EHLO QMTA13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbZHaSnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:43:50 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Aug 2009 14:43:50 EDT
Date: Mon, 31 Aug 2009 13:37:51 -0500
From: Tim Walberg <twalberg@comcast.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs compat_ioctl?
Message-ID: <20090831183751.GC19343@comcast.net>
Reply-To: Tim Walberg <twalberg@comcast.net>
Mail-Followup-To: Tim Walberg <twalberg@comcast.net>,
	Christoph Hellwig <hch@infradead.org>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
References: <4A9B759B.7020401@msgid.tls.msk.ru> <20090831123010.GA2368@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Content-Disposition: inline
In-Reply-To: <20090831123010.GA2368@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I still get these on 2.6.30.4 on sparc64 (32-bit userspace a la Debian etch=
):

sparcy:~# uname -a
Linux sparcy 2.6.30.4-sparcy #2 Sat Aug 1 21:14:46 CDT 2009 sparc64 GNU/Lin=
ux
sparcy:~# file $(which xfs_fsr)
/usr/sbin/xfs_fsr: ELF 32-bit MSB executable, SPARC32PLUS, V8+ Required, ve=
rsion 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.18=
, stripped
sparcy:~# dmesg | grep xfs | tail -5
[62457.467755] ioctl32(xfs_fsr:18816): Unknown cmd fd(7) cmd(c0a8586d){t:'X=
';sz:168} arg(00028e30) on /export
[62473.400273] ioctl32(xfs_fsr:18816): Unknown cmd fd(7) cmd(c0a8586d){t:'X=
';sz:168} arg(00028e30) on /export
[62481.928844] ioctl32(xfs_fsr:18816): Unknown cmd fd(7) cmd(c0a8586d){t:'X=
';sz:168} arg(00028e30) on /export
[62486.304567] ioctl32(xfs_fsr:18816): Unknown cmd fd(7) cmd(c0a8586d){t:'X=
';sz:168} arg(00028e30) on /export
[62490.833736] ioctl32(xfs_fsr:18816): Unknown cmd fd(7) cmd(c0a8586d){t:'X=
';sz:168} arg(00028e30) on /export

Haven't tried rolling my own xfs_progs binaries yet. xfs_db also fails with
a "Bus error" immediately on startup, but that may be a completely different
issue...



				tw




On 08/31/2009 08:30 -0400, Christoph Hellwig wrote:
>>	On Mon, Aug 31, 2009 at 11:02:51AM +0400, Michael Tokarev wrote:
>>	> Hello!
>>	>
>>	> I tried to resize an xfs filesystem on 64bit 2.6.30 kernel
>>	> using 32bit userland, and that does not work, in dmesg I see:
>>	>
>>	> ioctl32(xfs_growfs:24426): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12=
} arg(ffa56df4) on /mnt
>>	> ioctl32(xfs_growfs:24427): Unknown cmd fd(3) cmd(400c586e){t:'X';sz:12=
} arg(ff991254) on /mnt
>>	>
>>	> so apparently there's no compat_ioctl layer for these ioctls.
>>	>
>>	> Are there any plans to add these? :)
>>=09
>>	Are you sure you're testing 2.6.30?  The copat ioctls were added in
>>	2.6.28.
>>	--
>>	To unsubscribe from this list: send the line "unsubscribe linux-kernel" =
in
>>	the body of a message to majordomo@vger.kernel.org
>>	More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>	Please read the FAQ at  http://www.tux.org/lkml/
End of included message



--=20
+----------------------+
| Tim Walberg          |
| 830 Carriage Dr.     |
| Algonquin, IL 60102  |
| twalberg@comcast.net |
+----------------------+

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqcGH8ACgkQw+Wcj22rJWb9gwCdEO1sUsrQJSOAIDeRojsbo85v
ogIAoPBya+Taay/5rIWTwxtU1wcOhCwo
=3hx+
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--

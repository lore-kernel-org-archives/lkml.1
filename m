Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbZAKJuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbZAKJuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 04:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZAKJu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 04:50:26 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34593 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbZAKJuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 04:50:25 -0500
Date: Sun, 11 Jan 2009 20:50:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, travis@sgi.com,
       mingo@elte.hu
Subject: Re: cpumask change causes sparc build bustage
Message-Id: <20090111205008.db0a410e.sfr@canb.auug.org.au>
In-Reply-To: <20090111.003103.39502700.davem@davemloft.net>
References: <20090111.003103.39502700.davem@davemloft.net>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__11_Jan_2009_20_50_08_+1100_2NPpNzhxVnEL8+=4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__11_Jan_2009_20_50_08_+1100_2NPpNzhxVnEL8+=4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Sun, 11 Jan 2009 00:31:03 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> I'm surprised linux-next builds didn't catch this.

So am I.  http://kisskb.ellerman.id.au/kisskb/compiler/5/ shows my latest
builds of both linux-next and Linus' tree are OK for defconfig and
allnoconfig (allmodconfig fails for a different reason).

What is different about the failing config (compiler)?  Are there other
configs it would be sensible to build test?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__11_Jan_2009_20_50_08_+1100_2NPpNzhxVnEL8+=4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAklpwNAACgkQjjKRsyhoI8zgzgCY+lB8esA4SSbL6SckrGEvfkTW
yACdEpS7aKGfKWNAlsYxj//iTN88Pnk=
=AUI2
-----END PGP SIGNATURE-----

--Signature=_Sun__11_Jan_2009_20_50_08_+1100_2NPpNzhxVnEL8+=4--

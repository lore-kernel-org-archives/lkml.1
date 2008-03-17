Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYCQXe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYCQXe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 19:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYCQXeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 19:34:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34104 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbYCQXeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 19:34:20 -0400
Date: Tue, 18 Mar 2008 10:31:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] arch/powerpc/platforms/iseries/pci.c: Use time_* macros
Message-Id: <20080318103105.9482a8d4.sfr@canb.auug.org.au>
In-Reply-To: <1205746593-24820-4-git-send-email-caglar@pardus.org.tr>
References: <1205746593-24820-1-git-send-email-caglar@pardus.org.tr>
	<1205746593-24820-2-git-send-email-caglar@pardus.org.tr>
	<1205746593-24820-3-git-send-email-caglar@pardus.org.tr>
	<1205746593-24820-4-git-send-email-caglar@pardus.org.tr>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_Mar_2008_10_31_05_+1100_EU0ekh9klEP8wsPr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Mar_2008_10_31_05_+1100_EU0ekh9klEP8wsPr
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Mar 2008 11:36:26 +0200 S.=C3=87a=C4=9Flar Onur <caglar@pardus.o=
rg.tr> wrote:
>
> The functions time_before, time_before_eq, time_after, and time_after_eq =
are more robust for comparing jiffies against other values.
>=20
> So following patch implements usage of the time_after() macro, defined at=
 linux/jiffies.h, which deals with wrapping correctly
>=20
> Cc: linuxppc-dev@ozlabs.org
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__18_Mar_2008_10_31_05_+1100_EU0ekh9klEP8wsPr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH3v89TgG2atn1QN8RAsVjAKCJa01WiUaCCNbzwXoytMojbA+gUACfcUY5
SciRyIAq5SDecolsmmJkECE=
=/qD6
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Mar_2008_10_31_05_+1100_EU0ekh9klEP8wsPr--

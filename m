Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZIPJ4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZIPJ4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZIPJ4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:56:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:62980 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZIPJ4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=uQ0Shfw+T05PatPROnmCOO4+VrxUkexfc56u92khtMKyiIuCU3UrZfRQFavIBhA6lZ
         o+EZqWU7NyAUG83jwd6KJDp1Ql1C9frndxRc+GRu5tYuN9s3M+BonOML9JvCkP8RgN1b
         CUQGoInPbo0v6fuQrP6GEFOyv3cqwMGUr5Li4=
Date: Wed, 16 Sep 2009 12:57:02 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: uaccess_32.h typo
Message-ID: <20090916095702.GJ3717@localdomain.by>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nzri8VXeXB/g5ayr"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nzri8VXeXB/g5ayr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Peter,
There is a typo in x86 uaccess_32.h

--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -33,7 +33,7 @@ unsigned long __must_check __copy_from_user_ll_nocache_nozero
  * Copy data from kernel space to user space.  Caller must check
  * the specified block with access_ok() before calling this function.
  * The caller should also make sure he pins the user space address
- * so that the we don't result in page fault and sleep.
+ * so that we don't result in page fault and sleep.
  *
  * Here we special-case 1, 2 and 4-byte copy_*_user invocations.  On a fault
  * we return the initial request size (1, 2 or 4), as copy_*_user should do.

Could you please correct it? Thanks.


	Sergey
--nzri8VXeXB/g5ayr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqwtm4ACgkQfKHnntdSXjRAlgP/YskKhiqBkbKo+yyZL1kJcs4+
HrodSqX2pe4n5KPf7tqKWThtbrlU8dplagrSshLLWGMtjYzSJVRgBX/00TSsHU+W
QBjrWozmwK4A5kwFjKj25ChQnyW3WCZ5F95jnesDVy38aXakhP28BITDdpNWO1Ij
E6DUsXkssdXE6wBH5oQ=
=aLXH
-----END PGP SIGNATURE-----

--nzri8VXeXB/g5ayr--

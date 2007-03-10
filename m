Return-Path: <linux-kernel-owner+w=401wt.eu-S1767792AbXCJELP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767792AbXCJELP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767768AbXCJELH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:11:07 -0500
Received: from h80ad275d.async.vt.edu ([128.173.39.93]:38538 "EHLO
	h80ad275d.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767781AbXCJEKn (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:10:43 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2007 23:10:43 EST
Message-Id: <200703100403.l2A4355v008616@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
In-Reply-To: Your message of "Sat, 10 Mar 2007 09:57:32 +1100."
             <1173481052.32234.137.camel@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <1173419792.32234.131.camel@localhost.localdomain>
            <1173481052.32234.137.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1173499385_4248P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Mar 2007 23:03:05 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1173499385_4248P
Content-Type: text/plain; charset=us-ascii

On Sat, 10 Mar 2007 09:57:32 +1100, Rusty Russell said:

> +/* GCC is awesome. */
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0])			      \
>  	+ sizeof(typeof(int[1 - 2*!!__builtin_types_compatible_p(typeof(arr), \
>  		 typeof(&arr[0]))]))*0)

-/* GCC is awesome. */
+/* GCC leaves me speechless. */



--==_Exmh_1173499385_4248P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF8i35cC3lWbTT17ARAlwZAJ9be4Uqz2QEx484J3GvriDR52vRewCgyGWf
6xvgnBpCMGsXY0MrNByyB/M=
=lg0C
-----END PGP SIGNATURE-----

--==_Exmh_1173499385_4248P--

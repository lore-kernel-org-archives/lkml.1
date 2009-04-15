Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbZDOPUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbZDOPUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZDOPUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:20:04 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48581 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZDOPUC (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:20:02 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-04-14-17-24 uploaded
In-Reply-To: Your message of "Tue, 14 Apr 2009 17:24:57 PDT."
             <200904150024.n3F0Ovdo019569@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200904150024.n3F0Ovdo019569@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1239773374_19907P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Apr 2009 01:29:34 -0400
Message-ID: <22518.1239773374@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1239773374_19907P
Content-Type: text/plain; charset=us-ascii

On Tue, 14 Apr 2009 17:24:57 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-04-14-17-24 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

patch input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
is horribly busticated - was this dependent on another patch that was dropped?
The reference to 'i8042_nonfatal' is odd, I can't find it defined anywhere in the tree.

  CC      drivers/input/serio/i8042.o
In file included from drivers/input/serio/i8042.h:28,
                 from drivers/input/serio/i8042.c:85:
drivers/input/serio/i8042-x86ia64io.h:501: error: redefinition of 'i8042_dmi_reset_table'
drivers/input/serio/i8042-x86ia64io.h:380: note: previous definition of 'i8042_dmi_reset_table' was here
drivers/input/serio/i8042-x86ia64io.h: In function 'i8042_pnp_init':
drivers/input/serio/i8042-x86ia64io.h:619: error: 'i8042_nonfatal' undeclared (first use in this function)
drivers/input/serio/i8042-x86ia64io.h:619: error: (Each undeclared identifier is reported only once
drivers/input/serio/i8042-x86ia64io.h:619: error: for each function it appears in.)
make[2]: *** [drivers/input/serio/i8042.o] Error 1


--==_Exmh_1239773374_19907P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ5XC+cC3lWbTT17ARAlgfAKDsEvkmnFVltT3KWzvKjZGYpqTjfwCg9uHi
D9NdR0sv4JH7RXUSRcE8ews=
=xPLs
-----END PGP SIGNATURE-----

--==_Exmh_1239773374_19907P--

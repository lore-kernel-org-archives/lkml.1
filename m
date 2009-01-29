Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbZA2PuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbZA2PuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZA2Pty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:49:54 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51676 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZA2Ptx (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:49:53 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-01-28-02-17 uploaded
In-Reply-To: Your message of "Wed, 28 Jan 2009 02:19:09 PST."
             <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1233201805_3058P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Jan 2009 23:03:25 -0500
Message-ID: <18448.1233201805@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1233201805_3058P
Content-Type: text/plain; charset=us-ascii

On Wed, 28 Jan 2009 02:19:09 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-01-28-02-17 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists.patch

breaks the compile with CONFIG_KEXEC=n

  CC      kernel/printk.o
kernel/printk.c: In function 'log_buf_kexec_setup':
kernel/printk.c:142: error: implicit declaration of function 'VMCOREINFO_SYMBOL'
make[1]: *** [kernel/printk.o] Error 1
make: *** [kernel] Error 2


--==_Exmh_1233201805_3058P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJgSqNcC3lWbTT17ARArecAKDQ/I+XLKfIAdMFzFVjed/dyZ05/QCeI2Lz
odi2hL45Zg21Z3R0LWKPbXc=
=4tDu
-----END PGP SIGNATURE-----

--==_Exmh_1233201805_3058P--

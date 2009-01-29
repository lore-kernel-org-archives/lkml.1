Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbZA2Pum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbZA2Pum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZA2Puc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:50:32 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51682 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZA2Puc (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:50:32 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-01-28-02-17 uploaded
In-Reply-To: Your message of "Wed, 28 Jan 2009 02:19:09 PST."
             <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1233200603_3058P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Jan 2009 22:43:24 -0500
Message-ID: <10146.1233200604@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1233200603_3058P
Content-Type: text/plain; charset=us-ascii

On Wed, 28 Jan 2009 02:19:09 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-01-28-02-17 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

cpuset-fix-allocating-page-cache-slab-object-on-the-unallowed-node-when-memory-spread-is-set.patch

breaks compiles with CONFIG_CPUSETS=n

  CC      init/main.o
init/main.c: In function 'kernel_init':
init/main.c:876: error: 'struct task_struct' has no member named 'mems_allowed'
make[1]: *** [init/main.o] Error 1

Looks like it adds a reference to task->mems_allowed to kernel/main.c
and kernel/kthreads.c and neither one is wrapped with #ifdef CONFIG_CPUSETS
or anything.

--==_Exmh_1233200603_3058P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJgSXbcC3lWbTT17ARAgJQAKDDSIOtuHAwnbJZwEoj9ztxICaj9ACgxHpR
qJZ+ulsanPePDiZNvTBWRCI=
=e3u8
-----END PGP SIGNATURE-----

--==_Exmh_1233200603_3058P--

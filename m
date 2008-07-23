Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbYGWAUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbYGWAUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYGWAUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:20:32 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48009 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbYGWAUb (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:20:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: mingo@redhat.com, peterz@infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: 2.6.26-<mumble> question regarding kernel/lockdep.c
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1216772410_8518P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Jul 2008 20:20:10 -0400
Message-ID: <42591.1216772410@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1216772410_8518P
Content-Type: text/plain; charset=us-ascii

I was chasing after some weird behavior with lockdep, and I found that
almost none of the printk() calls in kernel/lockdep.c have a KERN_FOO
level specified.

It looks like it could use patching, but before I code something, I
need to know if the patch should be doing:

a) Adding the missing KERN_FOO levels..
or
b) Adding a comment explaining the subtle reason they're not there...

--==_Exmh_1216772410_8518P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIhnk6cC3lWbTT17ARAjbWAKD1nrxx8uCgA+vEfpsy91i1QMTZ9ACguAqF
udcy1rOk+O3D1ovSAqj30sk=
=U6UJ
-----END PGP SIGNATURE-----

--==_Exmh_1216772410_8518P--

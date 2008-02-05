Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbYBEQzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbYBEQzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYBEQyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:54:52 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40428 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbYBEQyv (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:54:51 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1
In-Reply-To: Your message of "Sun, 03 Feb 2008 17:16:34 PST."
             <20080203171634.58ab668b.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1202230436_3253P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Feb 2008 11:53:56 -0500
Message-ID: <10779.1202230436@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1202230436_3253P
Content-Type: text/plain; charset=us-ascii

On Sun, 03 Feb 2008 17:16:34 PST, Andrew Morton said:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/

Builds, boots, mostly seems to run for limited testing.

One note - the following commit(s) (and related CPA reworking) broke the NVidia
binary driver (which is OK, I can fix *that* part).  But can somebody explain
if this should have seen a trip through the -mm tree before it hit mainstream?
I didn't see these in 24-rc8-mm1:

commit af1e6844d60057774910a2d08bd75b67d73ba7d5
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Jan 30 13:34:08 2008 +0100

    x86: cpa: rename global_flush_tlb() to cpa_flush_all()

commit d1028a154c65d7fadd1b2d0276c077014d401ec7
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Wed Jan 30 13:34:07 2008 +0100

    x86: make various pageattr.c functions static


--==_Exmh_1202230436_3253P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHqJSkcC3lWbTT17ARAn3yAKCRZfYdrllFUXZ/YcACDpr49FXTjACgzwGz
rbx6lQ1nhZv1LF8tLF/EAtI=
=IveP
-----END PGP SIGNATURE-----

--==_Exmh_1202230436_3253P--

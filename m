Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbYJINBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbYJINBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 09:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758019AbYJINBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 09:01:13 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41353 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbYJINBN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:01:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@suse.cz>
Cc: Matthew Wilcox <matthew@wil.cx>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
In-Reply-To: Your message of "Thu, 09 Oct 2008 14:23:19 +0200."
             <20081009122319.GC1623@ucw.cz>
From: Valdis.Kletnieks@vt.edu
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <20081007105056.16d9e785.akpm@linux-foundation.org> <1223405963.26330.83.camel@lappy.programming.kicks-ass.net> <200810081335.44576.nickpiggin@yahoo.com.au> <20081008025209.GO25780@parisc-linux.org>
            <20081009122319.GC1623@ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1223556574_7177P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Oct 2008 08:49:35 -0400
Message-ID: <52983.1223556575@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1223556574_7177P
Content-Type: text/plain; charset=us-ascii

On Thu, 09 Oct 2008 14:23:19 +0200, Pavel Machek said:

> We have append-only files, and normal users should not be able to work
> around that restriction.

Can you give an example of two *plausible* starting offsets, and 2 write
lengths, which when subjected to this race manage to override the append-only
attribute? I believe somebody already checked the code, and for append-only
we force the offset in the kernel for *each* write.


--==_Exmh_1223556574_7177P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI7f3ecC3lWbTT17ARAiRdAJ9x0IisngS+YWbT5aoCoZ9zQsOZGwCdGV5b
svTuBKuLM49zwoQGHq0rEKo=
=W/qm
-----END PGP SIGNATURE-----

--==_Exmh_1223556574_7177P--

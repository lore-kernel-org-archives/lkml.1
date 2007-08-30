Return-Path: <linux-kernel-owner+w=401wt.eu-S1760268AbXH3OLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268AbXH3OLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXH3OLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:11:10 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52946 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbXH3OLJ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:11:09 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jakub@redhat.com, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
In-Reply-To: Your message of "Wed, 29 Aug 2007 16:15:45 PDT."
             <20070829161545.9fde1a5c.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <23252.1188396273@turing-police.cc.vt.edu> <3909.1188409058@turing-police.cc.vt.edu>
            <20070829161545.9fde1a5c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188482914_2967P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Aug 2007 10:08:34 -0400
Message-ID: <25082.1188482914@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188482914_2967P
Content-Type: text/plain; charset=us-ascii

On Wed, 29 Aug 2007 16:15:45 PDT, Andrew Morton said:

> So it's an interaction between the x86_64 vdso patches in Andi's tree and 
> newer glibc, and we don't know which one is getting it wrong yet?
> 
> If I ever get another -mm out the door (have been without electricity for
> several days) I'll drop the vdso changes until this is sorted out.

Don't bother, I tested this last night against a vanilla 2.6.23-rc3 kernel
and it had the same issue as well.  So Andi's vdso patches in his tree and/or
the -mm kernel aren't to blame - it's in mainline as well.  And it's been
in for a while - I also hit it with a 2.6.22-rc6-mm1 kernel.


--==_Exmh_1188482914_2967P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG1s9icC3lWbTT17ARAg6nAKDQ5RgCBYbmU4/TMb2W0WHxCmmtuwCfTPSA
O2a0dC9w//LDVM2Z4fMN8ng=
=XgMA
-----END PGP SIGNATURE-----

--==_Exmh_1188482914_2967P--

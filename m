Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbXH1SlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbXH1SlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 14:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbXH1SlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 14:41:08 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45340 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbXH1SlH (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 14:41:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@linux-foundation.org>, samuel@sortiz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sysctl: Properly register the irda binary sysctl numbers.
In-Reply-To: Your message of "Sat, 25 Aug 2007 11:59:53 MDT."
             <m1wsvjlckm.fsf@ebiederm.dsl.xmission.com>
From: Valdis.Kletnieks@vt.edu
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <23568.1187876026@turing-police.cc.vt.edu> <20070823141652.d488a6e0.akpm@linux-foundation.org> <m1wsvlmvu6.fsf_-_@ebiederm.dsl.xmission.com> <6634.1188030574@turing-police.cc.vt.edu> <m16433n55e.fsf@ebiederm.dsl.xmission.com> <2371.1188050875@turing-police.cc.vt.edu>
            <m1wsvjlckm.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188330255_3159P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Aug 2007 14:40:57 -0400
Message-ID: <5846.1188326457@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188330255_3159P
Content-Type: text/plain; charset=us-ascii

On Sat, 25 Aug 2007 11:59:53 MDT, Eric W. Biederman said:

> It looks like you don't have CONFIG_SYSCTL_SYSCALL defined, and it
> appears utsname_syscall and ipcdata_syscall both become NULL pointers
> if they aren't needed.  So the complaint is a false positive.

Yep. Nothing I actually use needs SYSCTL_SYSCALL, so I turned it off to
see what breaks...

--==_Exmh_1188330255_3159P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG1Gw4cC3lWbTT17ARAhPIAJ400NUcEZhFjHkcQwMmEKFAnaTGAwCg+KoU
YbrOpsbiaiLquDTLGyDC+qU=
=iQel
-----END PGP SIGNATURE-----

--==_Exmh_1188330255_3159P--

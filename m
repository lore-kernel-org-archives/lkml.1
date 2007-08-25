Return-Path: <linux-kernel-owner+w=401wt.eu-S932491AbXHYOIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbXHYOIM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 10:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbXHYOID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 10:08:03 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37540 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbXHYOIB (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 10:08:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrew Morton <akpm@linux-foundation.org>, samuel@sortiz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sysctl: Properly register the irda binary sysctl numbers.
In-Reply-To: Your message of "Sat, 25 Aug 2007 06:57:17 MDT."
             <m16433n55e.fsf@ebiederm.dsl.xmission.com>
From: Valdis.Kletnieks@vt.edu
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <23568.1187876026@turing-police.cc.vt.edu> <20070823141652.d488a6e0.akpm@linux-foundation.org> <m1wsvlmvu6.fsf_-_@ebiederm.dsl.xmission.com> <6634.1188030574@turing-police.cc.vt.edu>
            <m16433n55e.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188050875_6255P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 25 Aug 2007 10:07:55 -0400
Message-ID: <2371.1188050875@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188050875_6255P
Content-Type: text/plain; charset=us-ascii

On Sat, 25 Aug 2007 06:57:17 MDT, Eric W. Biederman said:

> It's good to have confirmation that my sysctl_check routine
> didn't find something else wrong.

If I understand the code, anything it whinges about is either an outright bug
or it's a round of ammo already chambered. ;)

As far as "something else wrong", I'm still seeing these in -rc3-mm1, but
they've been reported before against -rc2-mm2, I think:

[    0.628000] sysctl table check failed: /kernel/ostype .1.1 Missing strategy
[    0.628000] sysctl table check failed: /kernel/osrelease .1.2 Missing strategy
[    0.628000] sysctl table check failed: /kernel/version .1.4 Missing strategy
[    0.628000] sysctl table check failed: /kernel/hostname .1.7 Missing strategy
[    0.628000] sysctl table check failed: /kernel/domainname .1.8 Missing strategy
[    0.628000] sysctl table check failed: /kernel/shmmax .1.34 Missing strategy
[    0.628000] sysctl table check failed: /kernel/shmall .1.41 Missing strategy
[    0.628000] sysctl table check failed: /kernel/shmmni .1.45 Missing strategy
[    0.628000] sysctl table check failed: /kernel/msgmax .1.35 Missing strategy
[    0.628000] sysctl table check failed: /kernel/msgmni .1.42 Missing strategy
[    0.628000] sysctl table check failed: /kernel/msgmnb .1.36 Missing strategy
[    0.628000] sysctl table check failed: /kernel/sem .1.43 Missing strategy

And this isn't on an allyesconfig or allmodconfig. There may well be sysctl
code I didn't hit - my /lib/modules/2.6.23-rc3-mm1 is only about 10M, and
the Fedora kernels are weighing in at about 75M of /lib/modules a pop.

--==_Exmh_1188050875_6255P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG0De7cC3lWbTT17ARAijTAJwLUIbu/UMQw+RkmIy356Jqtgd+AQCgueIs
9sGIx0QKcFIs7tzaw2SdyOI=
=kLDH
-----END PGP SIGNATURE-----

--==_Exmh_1188050875_6255P--

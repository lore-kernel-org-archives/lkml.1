Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYAPMWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYAPMWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 07:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYAPMWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 07:22:21 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33828 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYAPMWU (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 07:22:20 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@ucw.cz>
Cc: Daniel Phillips <phillips@google.com>, David Chinner <dgc@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Al Boldi <a1426z@gawab.com>, Valerie Henson <val.henson@gmail.com>,
       Rik van Riel <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental fsck)
In-Reply-To: Your message of "Wed, 16 Jan 2008 12:51:44 +0100."
             <20080116115144.GE22460@elf.ucw.cz>
From: Valdis.Kletnieks@vt.edu
References: <200801090740.12989.a1426z@gawab.com> <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com> <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu> <20080113171916.GB4132@ucw.cz> <20080113174125.5f39ac64@lxorguk.ukuu.org.uk> <20080115201653.GA5639@elf.ucw.cz> <20080115214325.GN155407@sgi.com> <20080115230714.GC3573@elf.ucw.cz> <4d47a5d10801151544k3bc50223ob69c25d8732e3f12@mail.gmail.com>
            <20080116115144.GE22460@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200486036_2966P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 16 Jan 2008 07:20:36 -0500
Message-ID: <16153.1200486036@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200486036_2966P
Content-Type: text/plain; charset=us-ascii

On Wed, 16 Jan 2008 12:51:44 +0100, Pavel Machek said:

> I guess I should try to measure it. (Linux already does writeback
> caching, with 2GB of memory. I wonder how important disks's 2MB of
> cache can be).

It serves essentially the same purpose as the 'async' option in /etc/exports
(i.e. we declare it "done" when the other end of the wire says it's caught
the data, not when it's actually committed), with similar latency wins.  Of
course, it's impedance-matching for bursty traffic - the 2M doesn't do much
at all if you're streaming data to it.  For what it's worth, the 80G Seagate
drive in my laptop claims it has 8M, so it probably does 4 times as much
good as 2M. ;)

--==_Exmh_1200486036_2966P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHjfaUcC3lWbTT17ARAuh8AKDuMO2z/LU9eaU+1QeS/6k6wZnRbwCgkF8o
N8XX46OK6g53lJpdGWIbUgw=
=n5XN
-----END PGP SIGNATURE-----

--==_Exmh_1200486036_2966P--

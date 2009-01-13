Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZAMXJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZAMXJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZAMXJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:09:31 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59244 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbZAMXJb (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:09:31 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Prateek Donni <prateek.donni@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A kind of file monitor
In-Reply-To: Your message of "Tue, 13 Jan 2009 14:35:05 +0530."
             <a80c86b70901130105v74feff29y445a82e0694d3d89@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <a80c86b70901100833k7a2f3667hcada40f7737530@mail.gmail.com>
            <a80c86b70901130105v74feff29y445a82e0694d3d89@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231888168_3146P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Jan 2009 18:09:28 -0500
Message-ID: <12935.1231888168@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231888168_3146P
Content-Type: text/plain; charset=us-ascii

On Tue, 13 Jan 2009 14:35:05 +0530, Prateek Donni said:
> Hey guys , i needed some help on building a file monitor which
> monitors alll file accesses and manages historical data of the same,
> kindly tell if 'inotify' can be good enough for the same

You may or may not be better served looking at the audit subsystem, but
it's unclear what you need. Some things you have to consider:

1) Do you want all reads/writes, or is open/close/mmap sufficient?
2) What latency do you need?  Does the monitor need to deal with it in
real time (the same second or so), or is "auditd writes to a logfile and
we read it from a cron job" good enough?
3) What are the penalties/failure modes if you fail to capture an access event?

--==_Exmh_1231888168_3146P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJbR8ocC3lWbTT17ARAjRKAKDoKkjXCtL+Ngv2wNTfjkS6KDAkHACfQGgX
F2sd2iOA3xDzkNg0Xv65PHw=
=Oxfv
-----END PGP SIGNATURE-----

--==_Exmh_1231888168_3146P--

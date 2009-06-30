Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZF3UP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZF3UP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZF3UPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:15:49 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35946 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbZF3UPs (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:15:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-06-30-12-50 uploaded
In-Reply-To: Your message of "Tue, 30 Jun 2009 12:51:30 PDT."
             <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246392952_3574P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Jun 2009 16:15:52 -0400
Message-ID: <54770.1246392952@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246392952_3574P
Content-Type: text/plain; charset=us-ascii

On Tue, 30 Jun 2009 12:51:30 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-06-30-12-50 has been uploaded to

This dies with quilt 0.44, thusly:

Applying patch procfs-provide-stack-information-for-threads-v08.patch
can't find file to patch at input line 20
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|From: Stefani Seibold <stefani@seibold.net>
|
|A patch to give a better overview of the userland application stack usage,
|especially for embedded linux.
|
|Currently you are only able to dump the main process/thread stack usage
|which is showed in /proc/pid/status by the "VmStk" Value.  But you get no
|information about the consumed stack memory of the the threads.
|
|There is an enhancement in the /proc/<pid>/{task/*,}/*maps and which marks
|the vm mapping where the thread stack pointer reside with "[thread stack
|xxxxxxxx]".  xxxxxxxx is the maximum size of stack.  This is a value
|information, because libpthread doesn't set the start of the stack to the
|top of the mapped area, depending of the pthread usage.
|
|A sample output of /proc/<pid>/task/<tid>/maps looks like:
|
|08048000-08049000 r-xp 00000000 03:00 8312       /opt/z
|08049000-0804a000 rw-p 00001000 03:00 8312       /opt/z
--------------------------
No file to patch.  Skipping patch.
patch: **** /tmp/poPjWncl : No such file or directory
Patch procfs-provide-stack-information-for-threads-v08.patch does not apply (enforce with -f)

Yowza.  Not sure what makes it think there's an issue at line 20, looks to
*me* like the actual patch starts on line 77.

--==_Exmh_1246392952_3574P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKSnJ4cC3lWbTT17ARAs18AJ9CVqiCno8yM+IwnWG5s/wQhwFWGQCgkZ4U
s54W1GKTwgLFUNUFPCljQIE=
=iVkB
-----END PGP SIGNATURE-----

--==_Exmh_1246392952_3574P--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbYDLJmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbYDLJmb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 05:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbYDLJmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 05:42:21 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47701 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbYDLJmU (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 05:42:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc8-mm2
In-Reply-To: Your message of "Thu, 10 Apr 2008 20:33:54 PDT."
             <20080410203354.f0a6f464.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1207993317_3280P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 12 Apr 2008 05:41:57 -0400
Message-ID: <3572.1207993317@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1207993317_3280P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <3560.1207993309.1@turing-police.cc.vt.edu>

On Thu, 10 Apr 2008 20:33:54 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/

I'm pretty sure this one is for Ingo and Steven to sort out, their
names are all over git-sched.patch for this code.... :)

The following config will actually build on x86_64:

CONFIG_HAVE_FTRACE=y
# CONFIG_FTRACE is not set
CONFIG_FTRACE_STARTUP_TEST=y

However, at boot time, it dies a quick and horrid ker-splat and hangs without
doing anything visible at all, without even the decency of rebooting. I'm going
to guess that the startup test fandangos on memory that wasn't set up by the
non-present CONFIG_FTRACE.

I got into this state by saying 'y' to 'startup test' in make oldconfig,
then deciding I didn't want ftrace so I turned that *one* entry off in
make menuconfig - which left the startup test dangling.  Easy local workaround
was to just turn the test off too, so you guys can hash this one out at
your leisure...


--==_Exmh_1207993317_3280P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIAIPlcC3lWbTT17ARAoG+AKCbuIc4Q6PmgBrf2ZV+YO+DqBF0LQCgo9Oa
j/PRJzTjS3qzod+0POuoP2k=
=JMfO
-----END PGP SIGNATURE-----

--==_Exmh_1207993317_3280P--

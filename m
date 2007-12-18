Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbXLSAcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbXLSAcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbXLSAci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:32:38 -0500
Received: from natgw.netstream.ch ([62.65.128.28]:8454 "EHLO
	denkbrett.schottelius.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754769AbXLSAch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:32:37 -0500
X-Greylist: delayed 2153 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2007 19:32:37 EST
Date: Wed, 19 Dec 2007 00:56:39 +0100
From: Nico Schottelius <nico-kernel-20071219@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Out of memory and no killable processes: 2.6.22-2-686-bigmem
Message-ID: <20071218235639.GB21042@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel-20071219@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: denkbrett running Linux 2.6.23.11-denkbrett on i686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

We are running Debian with 2.6.22-2-686-bigmem on Dell Blade 1955 hardware
and get a Kernel Panic with oom + message that there are no processes
left to kill:

http://home.schottelius.org/~nico/unix/linux/oom_no_killable-2.6.22-1.jpeg

Anyone an idea, what's the cause for that? This error happened on two of
those machines,

What I can see in our analysis done with munin is that the number of
open inodes and inode table size decreased within some days from 40k
to next to zero. Munin uses

   awk '{print "used.value " $1-$2 "\nmax.value " $1}' < /proc/sys/fs/inode=
-nr

to log those value (happened on both machines).

Thanks for any hint and CC as usual, please.

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHaF43uL75KpiFGIwRAkINAJ4tI+8UGj9J5irV4GJlwVKpV5vBPwCfbLo9
ONjWkg4kJPf5qELCHlSwy0o=
=7hE1
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--

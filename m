Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYIRTgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYIRTgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 15:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbYIRTfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 15:35:55 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47949 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbYIRTfy (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 15:35:54 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: c1e_idle: don't mark TSC unstable if CPU has invariant TSC
In-Reply-To: Your message of "Thu, 18 Sep 2008 21:12:10 +0200."
             <20080918191210.GD23287@alberich.amd.com>
From: Valdis.Kletnieks@vt.edu
References: <20080918191210.GD23287@alberich.amd.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221766532_3536P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Sep 2008 15:35:32 -0400
Message-ID: <27087.1221766532@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221766532_3536P
Content-Type: text/plain; charset=us-ascii

On Thu, 18 Sep 2008 21:12:10 +0200, Andreas Herrmann said:
> .. otherwise TSC is marked unstable on AMD family 0x10 and 0x11 CPUs.

OK.  I'll bite (admittedly not having looked at the actual code yet).

If the TSC is in fact invariant, what's causing the kernel to mark it as
unstable? Sounds almost like a bug being papered over here...

--==_Exmh_1221766532_3536P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI0q2EcC3lWbTT17ARAmdwAJ9zmY1E8ZY0oT2J/XG8ACHDHtYPrwCgilwp
TZC/6+xOHSfrFdwMW1uLv/4=
=yNyv
-----END PGP SIGNATURE-----

--==_Exmh_1221766532_3536P--

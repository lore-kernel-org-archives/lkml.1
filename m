Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbYCGIXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbYCGIXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYCGIXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:23:25 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44115 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbYCGIXZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:23:25 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
In-Reply-To: Your message of "Fri, 07 Mar 2008 09:06:59 +0100."
             <alpine.LFD.1.00.0803070857360.3099@apollo.tec.linutronix.de>
From: Valdis.Kletnieks@vt.edu
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu> <20080306221602.790cd26e.akpm@linux-foundation.org> <4954.1204876349@turing-police.cc.vt.edu>
            <alpine.LFD.1.00.0803070857360.3099@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204878180_3634P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Mar 2008 03:23:00 -0500
Message-ID: <3450.1204878180@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204878180_3634P
Content-Type: text/plain; charset=us-ascii

On Fri, 07 Mar 2008 09:06:59 +0100, Thomas Gleixner said:
> On Fri, 7 Mar 2008, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 06 Mar 2008 22:16:02 PST, Andrew Morton said:
> > > > [   74.254402] CPU 1 is now offline
> > > > [   74.255395] SMP alternatives: switching to UP code
> > > > [   74.256373] BUG: unable to handle kernel paging request at ffffffff8020a023
> 
> Can you decode ffffffff8020a023 via addr2line please ?

It's been a long day, and I couldn't get addr2line to work, it kept saying '??:0'.

However, this is in my System.map:

ffffffff8020a000 t poll_idle
ffffffff8020a009 t do_nothing
ffffffff8020a00f T set_personality_64bit
ffffffff8020a041 T release_thread
ffffffff8020a07d T arch_randomize_brk

so set_personality_64bit+0x14 or so?

--==_Exmh_1204878180_3634P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH0PtjcC3lWbTT17ARAg/QAKDlIJtpqJr3+63bdNR2Z/Us331nQACcDDmW
c8QaAP0k29qr+PDVJ5zCAEk=
=BCVs
-----END PGP SIGNATURE-----

--==_Exmh_1204878180_3634P--

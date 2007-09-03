Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbXICQgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbXICQgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 12:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbXICQg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 12:36:28 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35797 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbXICQg1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 12:36:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Satyam Sharma <satyam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mm][resend] softlockup-improve-debug-output.patch fix
In-Reply-To: Your message of "Sun, 02 Sep 2007 18:07:06 +0530."
             <alpine.LFD.0.999.0709021803060.24993@enigma.security.iitk.ac.in>
From: Valdis.Kletnieks@vt.edu
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <alpine.LFD.0.999.0709020439290.20781@enigma.security.iitk.ac.in>
            <alpine.LFD.0.999.0709021803060.24993@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188837372_2902P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 03 Sep 2007 12:36:12 -0400
Message-ID: <6886.1188837372@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188837372_2902P
Content-Type: text/plain; charset=us-ascii

On Sun, 02 Sep 2007 18:07:06 +0530, Satyam Sharma said:
> 
> 
> On Sun, 2 Sep 2007, Satyam Sharma wrote:
> > 
> > --- kernel/softlockup.c~fix	2007-09-02 04:23:49.000000000 +0530
> > +++ kernel/softlockup.c	2007-09-02 04:34:45.000000000 +0530
>   ^^^^^^^^^^
> 
> Ick, I botched a trivial patch, it doesn't even apply. Updated one below
> (with indentation fix as added bonus :-)
> 
> 
> [PATCH -mm] softlockup-improve-debug-output.patch fix (v2)
> 
> kernel/softlockup.c: In function 'softlockup_tick':
> kernel/softlockup.c:125: warning: 'regs' is used uninitialized in this function
> 
> is a genuine bug (will cause an oops in all probability,

Thanks for catching this, it was actually managing to inspire a full-scale
panic - flashing LEDs and the like.  Now to go track down the probably
self-inflicted cause of the soft-lockup message.. ;)

--==_Exmh_1188837372_2902P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG3Df8cC3lWbTT17ARAi5IAJ45A84cSh5OzVKNxHaitcFl5SUiowCg43Iw
S1Zb5cynzNpxZK7gJ8b4s/8=
=OJ/9
-----END PGP SIGNATURE-----

--==_Exmh_1188837372_2902P--

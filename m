Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYGCM2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYGCM2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbYGCM1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:27:48 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43579 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbYGCM1r (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:27:47 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Woodhouse <dwmw2@infradead.org>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, Shaohua Li <shaohua.li@intel.com>,
       greg@kroah.com, Kay Sievers <kay.sievers@vrfy.org>, arjan@infradead.org
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New World Order firmware...
In-Reply-To: Your message of "Thu, 03 Jul 2008 11:30:29 BST."
             <1215081029.10393.517.camel@pmac.infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <4534.1215048758@turing-police.cc.vt.edu> <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet> <32146.1215066947@turing-police.cc.vt.edu> <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet> <1215077028.10393.497.camel@pmac.infradead.org> <65663.1215080245@turing-police.cc.vt.edu>
            <1215081029.10393.517.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215084867_4193P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jul 2008 07:34:27 -0400
Message-ID: <68763.1215084867@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1215084867_4193P
Content-Type: text/plain; charset=us-ascii

On Thu, 03 Jul 2008 11:30:29 BST, David Woodhouse said:

> > Anyhow, it appears the firmware_request() was just a bullet loaded in the
> > chamber waiting for me to pull the trigger 2 years later by setting
> > CONFIG_FIRMWARE_IN_KERNEL=n :)
> 
> No, the recent firmware changes haven't modified this. The
> FIRMWARE_IN_KERNEL option makes no difference here.

"D'Oh!" -- H. Simpson.
"Nevermind" - Emily Litella.

Actually, FIRMWARE_IN_KERNEL *did* make a difference - it busticated the tg3
driver and while fighting with the 'firmware: requesting tigon/tg3_tso.bin'
errors I had just inflicted on myself, I found the 'requesting intel-ucode/060f06'
messages as well - and totally failed to notice that the *previous* kernel
and initscripts had *all along* been doing a modprobe, which generated 2 requests
(one per CPU) which failed, and then the initscript ran microcode_ctl *anyhow*,
papering over the two failed requests.. ;)

--==_Exmh_1215084867_4193P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIbLlDcC3lWbTT17ARAhK5AJ9dLSTmQB6x4S8RlxffeBNhyxoOIACePWnr
iRQ/MTDKXltt+urrJndMXaY=
=MA9I
-----END PGP SIGNATURE-----

--==_Exmh_1215084867_4193P--

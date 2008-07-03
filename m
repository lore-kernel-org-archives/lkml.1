Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbYGCM2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbYGCM2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbYGCM1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:27:49 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43579 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbYGCM1s (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:27:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Woodhouse <dwmw2@infradead.org>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, Shaohua Li <shaohua.li@intel.com>,
       greg@kroah.com, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New World Order firmware...
In-Reply-To: Your message of "Thu, 03 Jul 2008 10:23:48 BST."
             <1215077028.10393.497.camel@pmac.infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <4534.1215048758@turing-police.cc.vt.edu> <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet> <32146.1215066947@turing-police.cc.vt.edu> <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
            <1215077028.10393.497.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215080245_4193P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jul 2008 06:17:25 -0400
Message-ID: <65663.1215080245@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1215080245_4193P
Content-Type: text/plain; charset=us-ascii

On Thu, 03 Jul 2008 10:23:48 BST, David Woodhouse said:

> The recent firmware changes haven't modified this. The important change
> seems to have been here (in 2006):
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a30a6a2c

Aha. That's the part I was missing. :)

>From the changelog for that commit, Shaohua Li wrote:

"with the changes, we should put all intel-ucode/xx-xx-xx microcode files
into the firmware dir (I had a tool to split previous big data file into
small one and later we will release new style data file).  The init script
should be changed to ..."

And apparently I got stuck between the unreleased tool to split the file,
and the release of the new style data file.

Anyhow, it appears the firmware_request() was just a bullet loaded in the
chamber waiting for me to pull the trigger 2 years later by setting
CONFIG_FIRMWARE_IN_KERNEL=n :)

The behavior is explained, and presumably Intel will eventually release
a method of getting the new-format bits, and all will be right with the
world (or at least this part of it.. ;)

--==_Exmh_1215080245_4193P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIbKc1cC3lWbTT17ARAt9dAJ4h08GkW6oijDjHDBgGfcAfvgasSACgy+kQ
KDbaOM3Aslz6oSlrjns+r1s=
=xZkT
-----END PGP SIGNATURE-----

--==_Exmh_1215080245_4193P--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYAGXFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYAGXFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYAGXE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:04:58 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49692 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYAGXE6 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:04:58 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Matthew Wilcox <matthew@wil.cx>
Cc: Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: Your message of "Mon, 07 Jan 2008 14:37:17 MST."
             <20080107213717.GB16309@parisc-linux.org>
From: Valdis.Kletnieks@vt.edu
References: <20080106144706.GA25419@elte.hu> <1199632845.5205.31.camel@localhost.localdomain> <20080106171158.GM20473@parisc-linux.org> <1199640983.5205.65.camel@localhost.localdomain> <20080106183402.GA7906@1wt.eu> <20080106185625.GM2082@does.not.exist> <20080106191044.GA1105@1wt.eu> <20080106195802.GN2082@does.not.exist> <20080106210813.GA10136@1wt.eu> <19438.1199739038@turing-police.cc.vt.edu>
            <20080107213717.GB16309@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199747065_2703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Jan 2008 18:04:25 -0500
Message-ID: <26581.1199747065@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199747065_2703P
Content-Type: text/plain; charset=us-ascii

On Mon, 07 Jan 2008 14:37:17 MST, Matthew Wilcox said:
> If you can reproduce a bug reliably, you can reproduce it without the
> nvidia module loaded.

Theoretically, at least.  Sometimes, in the real world, other constraints
enter into it...

You're welcome to stop by and figure out why (I've sunk multiple tens of hours
into trying already) the NVidia binary driver can handle the Gateway monitor
hanging off my docking station and the open-source one selects a non-functional
sync rate, or pay for a replacement (management doesn't want to shell out $$ to
replace a monitor that works just fine when the manufacturer's drivers/config
are installed - surprising, that).  Or I could get behind the docking station,
unplug the ergonomic keyboard, the power brick, the trackball, and the cat-5,
set the laptop up on the desk, find some way to arrange the laptop, cat-5,
trackball, power brick, and keyboard so things are reasonable to use for a long
day of typing, and wait for it to *maybe* happen again, and then put everything
back when it's safe to use the monitor again. Oh, and the open source driver
has some *horrid* color-banding issues on the laptop's LCD, as well, you're
welcome to fix those while you're at it.. ;)

And no, I'm *not* just winging it with the laptop for the day - I have enough
carpal tunnel issues *with* an ergonomic keyboard and a trackball, I'm not
going to press my luck with the onboard keyboard and mouse.

Or I can just say "screw it" and not bother reporting any bugs that aren't
easily repeatable before GDM gets started.

Guess which one ends up happening in the real world?


--==_Exmh_1199747065_2703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHgq/5cC3lWbTT17ARAmOYAKDuuvdAZ7BcfFL7wxT9YJJZm4RsqQCdHvJj
a5hjpimTeMPoPbg/Al9ZP5o=
=+2Lv
-----END PGP SIGNATURE-----

--==_Exmh_1199747065_2703P--

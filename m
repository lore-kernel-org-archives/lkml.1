Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYAIEDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYAIEDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYAIEDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:03:42 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38452 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYAIEDl (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:03:41 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Matthew Wilcox <matthew@wil.cx>
Cc: Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
In-Reply-To: Your message of "Mon, 07 Jan 2008 16:19:30 MST."
             <20080107231930.GC16309@parisc-linux.org>
From: Valdis.Kletnieks@vt.edu
References: <20080106171158.GM20473@parisc-linux.org> <1199640983.5205.65.camel@localhost.localdomain> <20080106183402.GA7906@1wt.eu> <20080106185625.GM2082@does.not.exist> <20080106191044.GA1105@1wt.eu> <20080106195802.GN2082@does.not.exist> <20080106210813.GA10136@1wt.eu> <19438.1199739038@turing-police.cc.vt.edu> <20080107213717.GB16309@parisc-linux.org> <26581.1199747065@turing-police.cc.vt.edu>
            <20080107231930.GC16309@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199851394_3703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 08 Jan 2008 23:03:14 -0500
Message-ID: <8425.1199851394@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199851394_3703P
Content-Type: text/plain; charset=us-ascii

On Mon, 07 Jan 2008 16:19:30 MST, Matthew Wilcox said:

> So you're saying that you can't find reliable ways to reproduce problems
> on demand?  Those are some of the lower quality bug reports, so I don't
> think we're losing much by having you not report them.

And in the next e-mail in my lkml folder we see:

On Mon, 07 Jan 2008 18:21:45 EST, Parag Warudkar said:
> BTW, I have so far tested 2.6.24-rc4/5/6/7 and 2.6.23.12 - all of
> which have this problem.
> 
> Yesterday I went back to using 2.6.22.15 and after a day's uptime it
> has not reproduced with the same config.
> 
> Time for git-bisect I suppose? (the only problem is that this takes
> anywhere between 20 minutes to 8 hrs to confirm reliably.)

Are you saying that we're not losing much if Parag says "screw it" and
doesn't report the problem?

--==_Exmh_1199851394_3703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD4DBQFHhEeCcC3lWbTT17ARAsmYAJjzVHPuZcMSp67tFS8H35sHHIyLAJ4pm0To
QaRRTPtHfCShChu/YF+48g==
=Jypo
-----END PGP SIGNATURE-----

--==_Exmh_1199851394_3703P--

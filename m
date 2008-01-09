Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYAIEB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYAIEB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYAIEBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:01:49 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49701 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYAIEBt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:01:49 -0500
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
Content-Type: multipart/signed; boundary="==_Exmh_1199851267_3703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 08 Jan 2008 23:01:07 -0500
Message-ID: <8336.1199851267@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199851267_3703P
Content-Type: text/plain; charset=us-ascii

On Mon, 07 Jan 2008 16:19:30 MST, Matthew Wilcox said:
> On Mon, Jan 07, 2008 at 06:04:25PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > Theoretically, at least.  Sometimes, in the real world, other constraints
> > enter into it...
> 
> So you're saying that you can't find reliable ways to reproduce problems
> on demand?  Those are some of the lower quality bug reports, so I don't
> think we're losing much by having you not report them.

I'm sure that *everybody* on this list would *love* to know how you find
a reliable way to reproduce all the bugs that start off with "after X days of
uptime".   But when you're chasing what might be a race condition with a
very small timing hole, you may need an event to happen several million times
before the accumulated chance of hitting it becomes appreciable.

--==_Exmh_1199851267_3703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHhEcDcC3lWbTT17ARAmyPAJsE0OHlYbURRy8hKMkHpcavm2UGWQCfYep9
IDAQ2Gwdp0girq2PGi4VKb0=
=hzjY
-----END PGP SIGNATURE-----

--==_Exmh_1199851267_3703P--

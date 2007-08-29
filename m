Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbXH2S2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbXH2S2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 14:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbXH2S2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 14:28:09 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44842 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbXH2S2I (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 14:28:08 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add source address to sunrpc svc errors
In-Reply-To: Your message of "Tue, 28 Aug 2007 15:19:07 EDT."
             <20070828191907.GE3764@fieldses.org>
From: Valdis.Kletnieks@vt.edu
References: <20070825012630.GB5431@gallifrey> <20070824185621.3f16f7c9.randy.dunlap@oracle.com> <20070825150927.GA29335@gallifrey> <20070827214333.GM3118@fieldses.org> <7788.1188328346@turing-police.cc.vt.edu>
            <20070828191907.GE3764@fieldses.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188411973_2981P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 29 Aug 2007 14:26:13 -0400
Message-ID: <6938.1188411973@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188411973_2981P
Content-Type: text/plain; charset=us-ascii

On Tue, 28 Aug 2007 15:19:07 EDT, "J. Bruce Fields" said:
> On Tue, Aug 28, 2007 at 03:12:26PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Mon, 27 Aug 2007 17:43:33 EDT, "J. Bruce Fields" said:
> > > I also wonder whether these shouldn't all be dprintk's instead of
> > > printk's.  One misbehaving client could create a lot of noise in the
> > > logs.
> > 
> > I shouldn't have to rebuild my kernel with debugging enabled just to see
> > who is throwing trash at my machine.
> 
> Fair enough.
> 
> The dprintk's throughout the nfs and sunrpc server and client code can
> be selectively enabled at runtime using a set of sysctls in
> sys/sunrpc/*_debug; see
> 
> 	include/linux/lockd/debug.h
> 	include/linux/nfsd/debug.h

I looked at nfsd/debug.h, and saw the NFSD_DEBUG usage, and thought "Wow, if I
built it without RPC_DEBUG, I'm screwed". I didn't see where RPC_DEBUG was
enabled if CONFIG_SYSCTL was defined - having "compile in debugging code"
equated to "system has sysctl support" was as unexpected as the guy today who
didn't realize you needed SCSI support for an IDE CD/ROM. ;)

"You are trapped in a twisty maze of little #ifdef's, all different"... ;)


--==_Exmh_1188411973_2981P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG1bpFcC3lWbTT17ARAgd/AKDXTUCI+sUq4+ZrDanKn544IyhpUQCffvxQ
GcfHN/2BxGzgu+GYbuSRDuc=
=lF9s
-----END PGP SIGNATURE-----

--==_Exmh_1188411973_2981P--

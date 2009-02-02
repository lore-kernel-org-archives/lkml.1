Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbZBBWqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbZBBWqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZBBWqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:46:08 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55930 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZBBWqH (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:46:07 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Chris Friesen <cfriesen@nortel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Doug Thompson <norsk5@yahoo.com>, ncunningham-lkml@crca.org.au,
       Pavel Machek <pavel@suse.cz>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       bluesmoke-devel@lists.sourceforge.net
Subject: Re: marching through all physical memory in software
In-Reply-To: Your message of "Mon, 02 Feb 2009 12:29:45 CST."
             <49873B99.3070405@nortel.com>
From: Valdis.Kletnieks@vt.edu
References: <715599.77204.qm@web50111.mail.re2.yahoo.com> <m1wscc7fop.fsf@fess.ebiederm.org>
            <49873B99.3070405@nortel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1233614746_15229P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Feb 2009 17:45:46 -0500
Message-ID: <37985.1233614746@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1233614746_15229P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 Feb 2009 12:29:45 CST, Chris Friesen said:
> The next question is who handles the conversion of the various different 
> arch-specific BIOS mappings to a standard format that we can feed to the 
> background "scrub" code.  Is this something that belongs in the edac 
> memory controller code, or would it live in /arch/foo somewhere?

If it's intended to be something basically stand-alone that doesn't require
an actual EDAC chipset, it should probably live elsewhere.  Otherwise, you get
into the case of people who don't enable it because they "know" their hardware
doesn't have an EDAC ability, even if they *could* benefit from the function.

On the other hand, if it's an EDAC-only thing, maybe under drivers/edac/$ARCH?


--==_Exmh_1233614746_15229P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJh3eacC3lWbTT17ARAsqrAKDNNbwYhjwFzQ3MXRkOi9qqTIOMXgCfZfBp
TObEc4Qd+Ohdh/Zr/FmDlec=
=j6YP
-----END PGP SIGNATURE-----

--==_Exmh_1233614746_15229P--

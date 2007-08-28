Return-Path: <linux-kernel-owner+w=401wt.eu-S1763011AbXH1T2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763011AbXH1T2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760262AbXH1TNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:13:00 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51810 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbXH1TM6 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:12:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add source address to sunrpc svc errors
In-Reply-To: Your message of "Mon, 27 Aug 2007 17:43:33 EDT."
             <20070827214333.GM3118@fieldses.org>
From: Valdis.Kletnieks@vt.edu
References: <20070825012630.GB5431@gallifrey> <20070824185621.3f16f7c9.randy.dunlap@oracle.com> <20070825150927.GA29335@gallifrey>
            <20070827214333.GM3118@fieldses.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188330344_3159P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Aug 2007 15:12:26 -0400
Message-ID: <7788.1188328346@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188330344_3159P
Content-Type: text/plain; charset=us-ascii

On Mon, 27 Aug 2007 17:43:33 EDT, "J. Bruce Fields" said:

> Looks like a reasonable idea to me, thanks!  Any objection to just
> calling it "svc_printk" instead of "svc_printkerr"?
> 
> I also wonder whether these shouldn't all be dprintk's instead of
> printk's.  One misbehaving client could create a lot of noise in the
> logs.

I shouldn't have to rebuild my kernel with debugging enabled just to see
who is throwing trash at my machine.  printk(KERN_INFO maybe and/or using
a printk_ratelimit.

--==_Exmh_1188330344_3159P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG1HOacC3lWbTT17ARAiQ0AJ9cgVA7PhV+kUApCwtNTu7NOvfqJACggbau
P1lrLEhnQP6gPNPAQKPprDg=
=jDFo
-----END PGP SIGNATURE-----

--==_Exmh_1188330344_3159P--

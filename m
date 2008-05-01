Return-Path: <linux-kernel-owner+w=401wt.eu-S1765705AbYEAThh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765705AbYEAThh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765733AbYEATgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:36:51 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52452 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765717AbYEATgu (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:36:50 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: Your message of "Thu, 01 May 2008 13:53:18 +0200."
             <200805011353.19335.rjw@sisk.pl>
From: Valdis.Kletnieks@vt.edu
References: <20080429.190352.137408408.davem@davemloft.net> <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org> <20080501055045.GC18597@1wt.eu>
            <200805011353.19335.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1209670599_3191P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 01 May 2008 15:36:39 -0400
Message-ID: <11481.1209670599@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1209670599_3191P
Content-Type: text/plain; charset=us-ascii

On Thu, 01 May 2008 13:53:18 +0200, "Rafael J. Wysocki" said:

> How about:
> 
> (1) Merge a couple of trees at a time (one tree at a time would be ideal, but
>     that's impossible due to the total number of trees).
> (2) After (1) give testers some time to report problems introduced by the
>     merge.
> (3) Wait until the most urgent problems are resolved.  Revert the offending
>     changes if there's no solution within given time.
> (4) Repeat for another couple of trees.
> (5) Arrange things so that every tree gets merged once every two months.

You can't get there from here (at least not very easily).

If you have 60 trees, and want a merge for each one every 2 months, you have to
average 1 tree a day.  How big a delay you want in step (2) directly impacts
how many trees you merge at once - if you want a week of cook time, you have to
merge 7 trees every Monday, and so on...


--==_Exmh_1209670599_3191P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIGhvHcC3lWbTT17ARAktGAJ0fvS17+GOyptEy4RPRJsDgVZx96wCdFjrp
5LMfJANw0oz05hXXG+/MdNU=
=jOYK
-----END PGP SIGNATURE-----

--==_Exmh_1209670599_3191P--

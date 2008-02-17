Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbYBQE1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbYBQE1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 23:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYBQE1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 23:27:41 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35146 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYBQE1k (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 23:27:40 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Willy Tarreau <w@1wt.eu>
Cc: Bill Davidsen <davidsen@tmr.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Driver removals
In-Reply-To: Your message of "Sat, 16 Feb 2008 08:39:08 +0100."
             <20080216073907.GT8953@1wt.eu>
From: Valdis.Kletnieks@vt.edu
References: <fp08q7$jv0$1@ger.gmane.org> <20080214082547.GJ12383@cs181133002.pp.htv.fi> <47B5E2FD.9060908@tmr.com> <20080215222830.GA9962@cs181133002.pp.htv.fi> <47B6377D.4050502@tmr.com> <26601.1203126747@turing-police.cc.vt.edu>
            <20080216073907.GT8953@1wt.eu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1203222445_2997P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 16 Feb 2008 23:27:25 -0500
Message-ID: <26786.1203222445@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1203222445_2997P
Content-Type: text/plain; charset=us-ascii

On Sat, 16 Feb 2008 08:39:08 +0100, Willy Tarreau said:

> I don't understand why kernel developers always think that users spend
> their whole time testing their new stuff. That is mostly true for a lot
> of desktop users, but definitely not for servers. On a server, you may
> *ignore* that a new driver exists for years. The basic make oldconfig
> does the stuff right.

Been there, done that.  We got a number of boxes that sit there for ages
between reboots and even longer between upgrades.  Deploying Solaris 10 was
like a 2-year process for some of our boxes (when the boxes are running the
Oracle databases that house the enterprise business systems, and your
organizational budget is pushing the $1B/year mark, everybody gets *really*
cautious to avoid a CLM while upgrading... ;)  And we may actually manage to
finally kill off our last AIX 4.3.3 box this quarter (4.3.3 was released all
the way back in Sep 1999, and EOL'ed back in 2004 - don't ask. :)

Of course, the difference is that we *expect* that there's a good chance that
if we try to subject that sort of box to 3 year's worth of updates, there's a
good chance we'll discover that some driver has been EOL'ed or otherwise
problematic on now-ancient hardware...

(And yes, there's a *lot* of risk-management going on centered around "What if
we have to patch Server23 for a critical kernel security issue?".  Of course,
if it was actually *feasible* to blindly upgrade-and-reboot twice a month, the
job could be done by a much less expensive patch monkey, so it's good job
security ;)





--==_Exmh_1203222445_2997P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHt7etcC3lWbTT17ARApCXAJ90tDCbdf3jMTFk5il0vCHn50Sd9gCgnact
jwilPgbeG/XS6qt+OZ7n6yI=
=N6fW
-----END PGP SIGNATURE-----

--==_Exmh_1203222445_2997P--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZADLgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZADLgQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZADLgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:36:00 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59354 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbZADLf7 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:35:59 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: David Newall <davidn@davidnewall.com>
Cc: Kyle Moffett <kyle@moffetthome.net>, Ben Goodger <goodgerster@gmail.com>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
In-Reply-To: Your message of "Sun, 04 Jan 2009 20:33:41 +1030."
             <4960897D.5030603@davidnewall.com>
From: Valdis.Kletnieks@vt.edu
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com> <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca> <495F0672.6020708@davidnewall.com> <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com> <496076A9.7030907@davidnewall.com> <f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>
            <4960897D.5030603@davidnewall.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231068940_3941P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 04 Jan 2009 06:35:40 -0500
Message-ID: <122713.1231068940@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231068940_3941P
Content-Type: text/plain; charset=us-ascii

On Sun, 04 Jan 2009 20:33:41 +1030, David Newall said:

> I don't understand why such a simple thing was unnecessarily
> complicated.  And causing crashes!  Ha ha ha or what?  A simple addition
> to zoneinfo was (and still is) all that is required.

Something to keep in mind is that the Posix standard does *NOT* say anything
about leap seconds - poke around in a 'struct tm' sometime.
That's why /usr/share/zoneinfo has separate 'posix' and 'right' subdirectories.

The fun starts when software using the 'right' rules tries to interact with
other software using the Posix rules (quite possibly running on a non-Unixy
system that doesn't even *use* zoneinfo).

Repeat after me: Not all the world is Linux.


--==_Exmh_1231068940_3941P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJYJ8McC3lWbTT17ARAj5EAKDTLX1+/OAyIO3vdFclUMr9mZgecgCggh/f
mlWIgYFRdaVMVU5j5zmAqNQ=
=1ZIw
-----END PGP SIGNATURE-----

--==_Exmh_1231068940_3941P--

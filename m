Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab0CHTjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:39:18 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:38353 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab0CHTjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:39:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: jim owens <owens6336@gmail.com>
Cc: David Newall <davidn@davidnewall.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Jeff Garzik <jeff@garzik.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode)
In-Reply-To: Your message of "Mon, 08 Mar 2010 11:22:15 EST."
             <4B952437.8020607@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <201003072132.10579.borntraeger@de.ibm.com> <4B94367E.9080506@garzik.org> <201003080853.42978.borntraeger@de.ibm.com> <4B9518DA.8010201@davidnewall.com>
            <4B952437.8020607@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1268077130_3874P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Mar 2010 14:38:50 -0500
Message-ID: <4987.1268077130@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4B95524B.02D9,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1268077130_3874P
Content-Type: text/plain; charset=us-ascii

On Mon, 08 Mar 2010 11:22:15 EST, jim owens said:

> No.  Your logic would be correct if rotating disks had
> similar speed at all locations.  Current disks are much
> faster at the 0 end than at the middle or highest address.
> 
> It is not unusual to see 2x difference in transfer speed
> so you always want the important stuff as low as possible.

On the flip side, seek time is so much larger than the time spent
actually reading that minimizing the seeks will improve total throughput
more.  Sure, maybe you spend 0.05ms reading instead of 0.1ms - but if
the seek took 0.75ms rather than 0.5ms you're still in the hole.

--==_Exmh_1268077130_3874P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLlVJKcC3lWbTT17ARAl4BAKCLFW+pPKSXPIIXdAUnL1t8FuJrwgCeO5pw
Gz3e+Oqotdz2eyohbglpyg4=
=vn5J
-----END PGP SIGNATURE-----

--==_Exmh_1268077130_3874P--


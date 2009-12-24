Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZLXXxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZLXXxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 18:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbZLXXxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 18:53:32 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:56900 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZLXXxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 18:53:31 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Carl <carlr@freemail.gr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CPU eaten by unknown code
In-Reply-To: Your message of "Thu, 24 Dec 2009 16:12:21 +0200."
             <cpueatenbyunknowncode123890udwn9w8nfd9we@vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <cpueatenbyunknowncode123890udwn9w8nfd9we@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1261698808_3923P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Dec 2009 18:53:28 -0500
Message-ID: <25319.1261698808@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4B33FEF9.006A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1261698808_3923P
Content-Type: text/plain; charset=us-ascii

On Thu, 24 Dec 2009 16:12:21 +0200, Carl said:

> The loop takes 1.2 seconds for about 138 seconds.
> The loop takes 2.4 second for about 45 seconds.
> And this repeats forever.
> 
> In other words, every 138 seconds something is "running" for
> 45 seconds and it takes 50% of my CPU time!

Thermal throttling?  Is the fan functional?  Can you monitor the CPU
temperature while running your testcase?

My second guess is something is causing a cpuspeed module to misfire and
drop the CPU to a 50% clock speed even though there's load on the system.
That one is easily testable - just do a 'grep MHz /proc/cpuinfo' during the
'fast' and 'slow' phases.

--==_Exmh_1261698808_3923P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLM/74cC3lWbTT17ARAgsmAJwPlIImHge7YoK4mLYkrWCrngn0RACg5lfT
+YfkjCJoWIz9OR5/xQZMCy8=
=fETf
-----END PGP SIGNATURE-----

--==_Exmh_1261698808_3923P--


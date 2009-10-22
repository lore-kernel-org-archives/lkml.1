Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZJVPRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZJVPRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbZJVPRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:17:02 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:50629 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbZJVPRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:17:00 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Leonidas ." <leonidas137@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Can current macro be accessed from interrupt context?
In-Reply-To: Your message of "Thu, 22 Oct 2009 04:10:49 PDT."
             <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1256224623_3496P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 22 Oct 2009 11:17:03 -0400
Message-ID: <5048.1256224623@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4AE07770.00C1,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1256224623_3496P
Content-Type: text/plain; charset=us-ascii

On Thu, 22 Oct 2009 04:10:49 PDT, "Leonidas ." said:

> My use case is to get process id from any context with CONFIG_4KSTACKS = 0 or 1.

You *do* realize that if you're in interrupt context, the value of 'current'
probably has absolutely nothing to do with the interrupt?  The process/thread
that is responsible for an I/O interrupt is probably in a blocked state waiting
for the I/O to complete, and the *running* process is often some other process.
And for some interrupts (timer, etc), all bets are off...

So given that the process ID is quite often totally pointless, what were you
trying to accomplish by getting the process ID?

--==_Exmh_1256224623_3496P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK4HdvcC3lWbTT17ARAtJxAJ4tQBY7lyDHC4oAaKxTOKd/B5ox0ACgvxhi
2QH3nXF9GV8bdO0TwgMvkKI=
=YccT
-----END PGP SIGNATURE-----

--==_Exmh_1256224623_3496P--


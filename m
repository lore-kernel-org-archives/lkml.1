Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbZL2SJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbZL2SJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 13:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZL2SJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 13:09:12 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:42364 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZL2SJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 13:09:11 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: simplify numerous param.h's by including <asm-generic/param.h>?
In-Reply-To: Your message of "Tue, 29 Dec 2009 12:30:23 EST."
             <alpine.LFD.2.00.0912291224520.2860@localhost>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LFD.2.00.0912291224520.2860@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1262110147_4680P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 29 Dec 2009 13:09:07 -0500
Message-ID: <9192.1262110147@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4B3A45C3.01B6,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1262110147_4680P
Content-Type: text/plain; charset=us-ascii

On Tue, 29 Dec 2009 12:30:23 EST, "Robert P. J. Day" said:
> 
>   a brief perusal of the numerous param.h files under
> arch/<arch>/include/asm shows that most of them could be replaced with
> a simple
> 
>   #include <asm-generic/param.h>

>   worth doing?  not worth doing?

Anytime you can fix "You are in a twisty maze of #include files, all subtly
different" issues, it is a Good Thing.

Thanks for all the de-cruftifying efforts you've made.

--==_Exmh_1262110147_4680P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLOkXDcC3lWbTT17ARAhvbAKDBzq+oleWV1pE+QRKrf2oF7Pss5wCguPh5
wsJy1oWMUcQ4IvH0NldosKk=
=tp92
-----END PGP SIGNATURE-----

--==_Exmh_1262110147_4680P--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXEQPBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXEQPBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 11:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXEQPBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 11:01:48 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59677 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbXEQPBr (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 11:01:47 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Anand Jahagirdar <anandjigar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Attack
In-Reply-To: Your message of "Thu, 17 May 2007 20:15:32 +0530."
             <25ae38200705170745t4a80e7eer413b3c2bb0c5a327@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <25ae38200705170745t4a80e7eer413b3c2bb0c5a327@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1179414105_3622P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 17 May 2007 11:01:45 -0400
Message-ID: <4051.1179414105@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1179414105_3622P
Content-Type: text/plain; charset=us-ascii

On Thu, 17 May 2007 20:15:32 +0530, Anand Jahagirdar said:
> Hello All
>               I have set per user process limit ( ulimit) for both
> root and guest account as 8000 by using option ulimit -u 8000.this is
> Hard limit.  still fork bombing attack killed the box and machine
> needed reboot. will any body please tell me why this is so? i have
> tried all this attack on machine with FC6 and Linux kernel 2.6.18.

Convince me that your machine in fact has sufficient resources to spawn 8000
processes.

Then retry it with "ulimit -u 100", and then do a binary search from 100 to 8000
to find out what value it stops working at.

--==_Exmh_1179414105_3622P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGTG5ZcC3lWbTT17ARAjHnAJ45ifRsggAVK/K1LmDVsA50O/xsowCfet9e
tiGwRW0Q1mkAlH4mcTJpiQk=
=xQ6p
-----END PGP SIGNATURE-----

--==_Exmh_1179414105_3622P--

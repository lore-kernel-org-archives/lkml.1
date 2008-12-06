Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYLFHSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYLFHSw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 02:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbYLFHSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 02:18:42 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53540 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYLFHSm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 02:18:42 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Nick Andrew <nick@nick-andrew.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/3] Sample refactor of socket.c to use recursive printk
In-Reply-To: Your message of "Sat, 06 Dec 2008 18:00:23 +1100."
             <20081206070023.29149.92171.stgit@marcab.local.tull.net>
From: Valdis.Kletnieks@vt.edu
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net>
            <20081206070023.29149.92171.stgit@marcab.local.tull.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1228547913_5654P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 06 Dec 2008 02:18:34 -0500
Message-ID: <24518.1228547914@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1228547913_5654P
Content-Type: text/plain; charset=us-ascii

On Sat, 06 Dec 2008 18:00:23 +1100, Nick Andrew said:
> Sample refactor of socket.c to use recursive printk

I think we'd all appreciate it a lot if, instead of pointless code churn
in socket.c, you used it to fix an *actual* problem - like any of the
many places where we have issues with interleaved output in dmesg because
a function had to use 2 or 3 printk calls to build up a line.

In your 0/3 you point at sound/core/misc.c and drivers/cpufreq/cpufreq.c,
both of those would be better than socket.c

--==_Exmh_1228547913_5654P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJOidJcC3lWbTT17ARAmB5AKCInbR/jV+6YDh4r4zP2D3JpqhltACgt1HT
qn8Q4i3k88zIQlRHziGUojs=
=tAy7
-----END PGP SIGNATURE-----

--==_Exmh_1228547913_5654P--

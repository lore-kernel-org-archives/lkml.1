Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbZCQWCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbZCQWCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbZCQWCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:02:35 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55936 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067AbZCQWCe (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:02:34 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jkosina@suse.cz, gregkh@suse.de, linux-kernel@vger.kernel.org,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: 29-rc-mmotm - HID/USB wedge w/ WARNING: at kernel/workqueue.c:371
In-Reply-To: Your message of "Tue, 17 Mar 2009 13:54:24 PDT."
             <20090317135424.9151c4f8.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <6648.1237271589@turing-police.cc.vt.edu>
            <20090317135424.9151c4f8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1237327272_3640P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Mar 2009 18:01:12 -0400
Message-ID: <37742.1237327272@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1237327272_3640P
Content-Type: text/plain; charset=us-ascii

On Tue, 17 Mar 2009 13:54:24 PDT, Andrew Morton said:

> It's an error in workqueue-avoid-recursion-in-run_workqueue.patch, methinks.

Thanks for the diagnosis - I got as far as realizing that any backtrace that
included flush_cpu_workqueue() and worker_thread() had a problem and got
stuck there.

I'm going to throw some printk's into the usb_reset_device() area and related
code, and see if I can figure out why a cooling pad was able to trigger it (was
seeing a hit every 90 mins or so at home, have been up over 7 hours straight
in the office).

I'll let somebody who understands the code better figure out what should be
happening once we get into that reset situation.

--==_Exmh_1237327272_3640P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJwB2ocC3lWbTT17ARAnGbAJ4lZaX9JKJtCtgbvzqZE2DptqDajwCguNI/
vB32DQZEwnzvzGYyP5Z1SNI=
=X+TH
-----END PGP SIGNATURE-----

--==_Exmh_1237327272_3640P--

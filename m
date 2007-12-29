Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbXL2CPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbXL2CPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbXL2CPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:15:43 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45794 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbXL2CPn (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:15:43 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.23(?)=<] X used greatest stack depth: N bytes left
In-Reply-To: Your message of "Sat, 29 Dec 2007 01:58:44 +0100."
             <6101e8c40712281658i2ac7a27du4b0964afd043280e@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <6101e8c40712281311p446f64e1xb28f8fc273545041@mail.gmail.com> <20071228153258.bef76bb2.randy.dunlap@oracle.com>
            <6101e8c40712281658i2ac7a27du4b0964afd043280e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198894533_2814P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Dec 2007 21:15:33 -0500
Message-ID: <25148.1198894533@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198894533_2814P
Content-Type: text/plain; charset=us-ascii

On Sat, 29 Dec 2007 01:58:44 +0100, "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" said:

> sure, but to 2.6.22 or 2.6.23-rcX (with merged the cfs scheduler)
> don't show this warnings, but the CONFIG_DEBUG_STACK_USAGE is enabled.
> 

And I look in your dmesg-2.6.24-rc6-wifi0, and I see in the last 15 lines or so:

Write protecting the kernel text: 3528k
Write protecting the kernel read-only data: 890k
khelper used greatest stack depth: 6328 bytes left
stty used greatest stack depth: 6180 bytes left
mount used greatest stack depth: 6156 bytes left
mknod used greatest stack depth: 5932 bytes left
Adding 2048276k swap on /dev/sda2.  Priority:-1 extents:1 across:2048276k
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
XFS mounting filesystem sda4
Ending clean XFS mount for filesystem: sda4
skge eth0: enabling interface
ADDRCONF(NETDEV_UP): eth0: link is not ready
wpa_supplicant used greatest stack depth: 5740 bytes left
eth1: no IPv6 routers present
dhclient3 used greatest stack depth: 5500 bytes left

So what message are you saying you don't see?  I see a bunch of "used greatest
stack" messages there?

--==_Exmh_1198894533_2814P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD4DBQFHda3FcC3lWbTT17ARAi8LAKD2CN0y5amZxKjsomJ1aS8zwyVJjwCWM/Mf
RJZSFjk+NBoc6c5yZbAMFQ==
=xvdT
-----END PGP SIGNATURE-----

--==_Exmh_1198894533_2814P--

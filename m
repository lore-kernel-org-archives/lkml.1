Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbZCJRXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbZCJRXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbZCJRWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:22:43 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35389 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192AbZCJRWm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:22:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: porte64@free.fr
Cc: linux-kernel@vger.kernel.org
Subject: Re: read-only partitions: does the policy apply to all metadata ?
In-Reply-To: Your message of "Tue, 10 Mar 2009 17:26:44 BST."
             <355270241.1702481236702404399.JavaMail.root@spooler8-g27.priv.proxad.net>
From: Valdis.Kletnieks@vt.edu
References: <355270241.1702481236702404399.JavaMail.root@spooler8-g27.priv.proxad.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1236705759_3963P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Mar 2009 13:22:39 -0400
Message-ID: <29610.1236705759@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1236705759_3963P
Content-Type: text/plain; charset=us-ascii

On Tue, 10 Mar 2009 17:26:44 BST, porte64@free.fr said:
> When a partition is mounted as read-only, does the kernel
> really prevent ANY byte to be written to it, including
> any metadata ?

It's very hard to come up with a workable way to do a true read-only
mount of a journaled filesystem such as ext3 - what do you do if there's
anything in the journal that needs to be replayed?

Your best bet is to not worry about the filesystem, and look at flagging the
underlying block device as read-only.

--==_Exmh_1236705759_3963P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJtqHfcC3lWbTT17ARAuE8AJ99I0HrSJhawOu/txmbmvLkLPi9DwCeKtfB
dLpZwS+sFKflIMei2idwmSg=
=jDxZ
-----END PGP SIGNATURE-----

--==_Exmh_1236705759_3963P--

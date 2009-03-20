Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZCTOdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZCTOdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZCTOdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:33:07 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56729 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZCTOdG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:33:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Oliver Neukum <oliver@neukum.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, jkosina@suse.cz,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 29-rc-mmotm - HID/USB wedge w/ WARNING: at kernel/workqueue.c:371
In-Reply-To: Your message of "Wed, 18 Mar 2009 08:48:50 BST."
             <200903180848.51755.oliver@neukum.org>
From: Valdis.Kletnieks@vt.edu
References: <6648.1237271589@turing-police.cc.vt.edu> <20090317195004.18fb6af6.akpm@linux-foundation.org> <49C069F2.5040003@cn.fujitsu.com>
            <200903180848.51755.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1237556528_2961P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Mar 2009 09:42:08 -0400
Message-ID: <25338.1237556528@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1237556528_2961P
Content-Type: text/plain; charset=us-ascii

On Wed, 18 Mar 2009 08:48:50 BST, Oliver Neukum said:
> Very well, here's a patch.
> Please test.

> 	Regards
>		Oliver
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index bc017cd..4306cb1 100644

Applied and tested, over the past 2 evenings it's gotten about 18 hours of
runtime with the evil cooling pad without a problem - before it was rarely
living more than 90 minutes at a time. So this seems to have fixed the
workqueue issue I was seeing.

Thanks for the patch.. :)


--==_Exmh_1237556528_2961P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJw50wcC3lWbTT17ARAsNQAKCw/OA5lQsPkFnCD1XvQ9qCWYyngwCeOp2S
++TBt5bjwwBX0HulQirRXhQ=
=OuCt
-----END PGP SIGNATURE-----

--==_Exmh_1237556528_2961P--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbYIAJle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbYIAJle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYIAJl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:41:26 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54150 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbYIAJlZ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:41:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.27-rc5-mmotm0829 - lvm issues at boot, possible disk_devt() related?
In-Reply-To: Your message of "Mon, 01 Sep 2008 09:58:40 +0200."
             <48BBA0B0.5070309@kernel.org>
From: Valdis.Kletnieks@vt.edu
References: <4963.1220240176@turing-police.cc.vt.edu>
            <48BBA0B0.5070309@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1220260557_4797P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 01 Sep 2008 05:15:58 -0400
Message-ID: <7045.1220260558@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1220260557_4797P
Content-Type: text/plain; charset=us-ascii

On Mon, 01 Sep 2008 09:58:40 +0200, Tejun Heo said:

> Yeah, I made a mistake converting two of them and devt lookup fails when
> the disk is zero sized.  Bartlomiej debugged the problem and posted a
> patch and I followed up with an updated patch.  It should be fine in the
> next round.
> 
>   http://article.gmane.org/gmane.linux.kernel.next/2663
>   http://article.gmane.org/gmane.linux.kernel.next/2676
> 
> If you're seeing other problems, please let me know.

Confirming - 2.6.27-rc5-mmotm0829 plus the merge of the 2 above patches
does find the LVM volumes and come up.  Thanks for the clue.. :)

--==_Exmh_1220260557_4797P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIu7LNcC3lWbTT17ARAk3JAKDWhw+6mgL97kR88bdONijSEwd6YgCgribv
PeS8S4SHIWwfW1Rb9+b5vUQ=
=7mPo
-----END PGP SIGNATURE-----

--==_Exmh_1220260557_4797P--

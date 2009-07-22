Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZGVS0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZGVS0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 14:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbZGVS0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 14:26:22 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35880 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZGVS0W (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 14:26:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Tweedie <sct@redhat.com>, Andreas Dilger <adilger@sun.com>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: mmotm 2009-07-16-14-32 - lockdep whinge in ext3/quota code
In-Reply-To: Your message of "Wed, 22 Jul 2009 18:19:23 +0200."
             <20090722161923.GD19072@duck.suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <200907162134.n6GLY2kt019816@imap1.linux-foundation.org> <15072.1248268669@turing-police.cc.vt.edu>
            <20090722161923.GD19072@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248287132_2718P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Jul 2009 14:25:32 -0400
Message-ID: <3025.1248287132@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248287132_2718P
Content-Type: text/plain; charset=us-ascii

On Wed, 22 Jul 2009 18:19:23 +0200, Jan Kara said:

> From df60fe9a9d554070e6135087e154bd5aad2cc1b5 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Wed, 22 Jul 2009 18:12:17 +0200
> Subject: [PATCH] quota: Silence lockdep on quota_on
> 
> Commit d01730d74d2b0155da50d44555001706294014f7 didn't completely fix
> the problem since we still take dqio_mutex and i_mutex in the wrong
> order. Move taking of i_mutex further down (luckily it's needed only
> for updating inode flags) below where dqio_mutex is taken.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied that fix to the -mmotm I was testing, and the kernel booted quietly.
Feel free to attach a:

Tested-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

as it goes upstream.  Thanks for the fast patch.


--==_Exmh_1248287132_2718P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKZ1mccC3lWbTT17ARAm9rAJ0V9pKovSzDaDo1lMIBGAt45bAIHQCgqPfv
9VuvYtaXm2HWgEFVnLCga8k=
=nEkn
-----END PGP SIGNATURE-----

--==_Exmh_1248287132_2718P--

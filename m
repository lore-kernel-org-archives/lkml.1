Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbXIEP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbXIEP6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbXIEP6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:58:07 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33387 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbXIEP6G (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:58:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1
In-Reply-To: Your message of "Wed, 05 Sep 2007 08:12:07 PDT."
             <20070905081207.1d8a0e05.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <26495.1189003060@turing-police.cc.vt.edu>
            <20070905081207.1d8a0e05.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1189007881_2894P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Sep 2007 11:58:01 -0400
Message-ID: <3403.1189007881@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1189007881_2894P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Sep 2007 08:12:07 PDT, Andrew Morton said:

> Seems to me that there's a missing pte_unmap_lock() in insert_page().
> 
> Also, a hunk in do_anonymous_page() is indented one tabstop too far, which
> makes me suspect that patch(1) might have put it in the wrong place. 
> Balbir, can you please check that?
> 
> diff -puN mm/memory.c~memory-controller-memory-accounting-v7-fix mm/memory.c
> --- a/mm/memory.c~memory-controller-memory-accounting-v7-fix
> +++ a/mm/memory.c
> @@ -1135,7 +1135,7 @@ static int insert_page(struct mm_struct 

Confirming that this patch fixes things.

Tested-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1189007881_2894P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG3tIJcC3lWbTT17ARAlexAKCSLvZ8HAbYuSIOtmozf97bZkWuugCfUiFA
weVJi43rBqmLJbYiwri2Tkc=
=Xbt3
-----END PGP SIGNATURE-----

--==_Exmh_1189007881_2894P--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbZIYRVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbZIYRVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 13:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZIYRVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 13:21:06 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51097 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZIYRVG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 13:21:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andreas Gruenbacher <agruen@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: new O_NODE open flag
In-Reply-To: Your message of "Fri, 25 Sep 2009 13:37:47 BST."
             <20090925123747.GA31228@gallifrey>
From: Valdis.Kletnieks@vt.edu
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu> <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu>
            <20090925123747.GA31228@gallifrey>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1253899252_2918P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Sep 2009 13:20:52 -0400
Message-ID: <9988.1253899252@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1253899252_2918P
Content-Type: text/plain; charset=us-ascii

On Fri, 25 Sep 2009 13:37:47 BST, "Dr. David Alan Gilbert" said:

> Given an fd opened in this way is it possible to reopen it normally and
> be guarenteed to get the same object?

It's not possible even without this flag. Consider:

        fd1 = open("/tmp/foo",flags);
        rc = rename("/tmp/foo","/tmp/bar");
        fd2 = open("/tmp/foo",flags);

Or were you asking if *absent that sort of tomfoolery* if it would work?

--==_Exmh_1253899252_2918P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKvPv0cC3lWbTT17ARAvs2AJ9yrHE+Uw5kwTEe7b9pBZZMwNvOjgCg4gGu
5P25hI/VFnTiK/NOMkhOWVc=
=Vfdk
-----END PGP SIGNATURE-----

--==_Exmh_1253899252_2918P--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752650AbZIYVSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbZIYVSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 17:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZIYVSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 17:18:40 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47324 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbZIYVSj (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 17:18:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andreas Gruenbacher <agruen@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: new O_NODE open flag
In-Reply-To: Your message of "Fri, 25 Sep 2009 19:35:23 BST."
             <20090925183523.GA6065@gallifrey>
From: Valdis.Kletnieks@vt.edu
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu> <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu> <20090925123747.GA31228@gallifrey> <9988.1253899252@turing-police.cc.vt.edu>
            <20090925183523.GA6065@gallifrey>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1253913514_2918P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Sep 2009 17:18:34 -0400
Message-ID: <19645.1253913514@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1253913514_2918P
Content-Type: text/plain; charset=us-ascii

On Fri, 25 Sep 2009 19:35:23 BST, "Dr. David Alan Gilbert" said:

> I know it's not possible without this flag, my interest is whether
> it would be possible WITH this flag to promote an fd opened with the
> O_NODE to a normal fd, guaranteeing that it's still operating on the
> same object.

Well, maybe the question is if we should treat "promote" differently than
"re-open"?

(And now I'm wondering what happens if you dup() one of these beasts....)

--==_Exmh_1253913514_2918P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKvTOqcC3lWbTT17ARAs97AJ4nTBjrPPdhH9lCxdJrJC1lnuUOFACgh4yT
Mpp/3jf5pOuFT3p1V0Mf3yY=
=Th5X
-----END PGP SIGNATURE-----

--==_Exmh_1253913514_2918P--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZAMSFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZAMSFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZAMSFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:05:10 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37487 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZAMSFJ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:05:09 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [why oom_adj does not work] Re: Linux killed Kenny, bastard!
In-Reply-To: Your message of "Tue, 13 Jan 2009 18:21:06 +0300."
             <20090113152106.GA1134@ioremap.net>
From: Valdis.Kletnieks@vt.edu
References: <20090112153304.GA19995@ioremap.net> <20090112154456.GA27269@redhat.com> <20090112154827.GB20743@ioremap.net> <20090112155108.2646b3ae@lxorguk.ukuu.org.uk> <20090113135246.GA29251@ioremap.net> <20090113140627.507f15e1@lxorguk.ukuu.org.uk> <20090113142423.GA30710@ioremap.net> <661de9470901130700m34c4938cm6feeb6fc561d605a@mail.gmail.com>
            <20090113152106.GA1134@ioremap.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231869877_4143P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Jan 2009 13:04:37 -0500
Message-ID: <24551.1231869877@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231869877_4143P
Content-Type: text/plain; charset=us-ascii

On Tue, 13 Jan 2009 18:21:06 +0300, Evgeniy Polyakov said:

> Using oom_adj? Because there is no way I can determine which number to
> put there. It is not even documented for those who do not read kernel
> sources. Even after that: oom_score changes with time, and having 1/2 or
> 8 oom_adj is correct right now, it will not be in a few moments.

In that case, the *real* problem to be fixed is a lack of documentation.
It should be possible to add a blurb somewhere in Documentation/* that
says:

"echo 10000 > oom_adjust" is guaranteed to make this process the first one
up against the wall when the revolution comes (for some value of 10000, of
course).

--==_Exmh_1231869877_4143P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJbNe1cC3lWbTT17ARArFsAKC1vODBC8GQJwjFlkmgCxMo8Lw5GgCfW+eh
VjhTWGsBCR9RaLukdql9BbA=
=4xCm
-----END PGP SIGNATURE-----

--==_Exmh_1231869877_4143P--

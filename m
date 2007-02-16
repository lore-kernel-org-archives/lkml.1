Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbXBPITy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbXBPITy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966196AbXBPITy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:19:54 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44968 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbXBPITx (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:19:53 -0500
Message-Id: <200702160819.l1G8JnmZ013706@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Manu Abraham <abraham.manu@gmail.com>, Mws <mws@twisted-brains.org>,
       v j <vj.linux@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
In-Reply-To: Your message of "Thu, 15 Feb 2007 09:32:30 EST."
             <Pine.LNX.4.61.0702150913020.1735@chaos.analogic.com>
From: Valdis.Kletnieks@vt.edu
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <200702151254.39058.mws@twisted-brains.org> <1a297b360702150451n3dca1140ra6827cfde020eed5@mail.gmail.com>
            <Pine.LNX.4.61.0702150913020.1735@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1171613989_6166P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Feb 2007 03:19:49 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1171613989_6166P
Content-Type: text/plain; charset=us-ascii

On Thu, 15 Feb 2007 09:32:30 EST, "linux-os (Dick Johnson)" said:
> There are a lot of device drivers that will never make it into the
> mainline kernel because they are for one-of-a-kind devices or boards
> that companies embed into their products. Nobody would even want a
> copy of the software to interface with something that they would
> never even have. When Version 2.6 started, it became necessary to
> use special tools and procedures to compile a module that was not
> inside the mainline kernel. However, it was still quite easy. Recently,
> somebody, apparently with an advanced degree in obfuscation, has made
> that more difficult. This is abuse, pure and simple. That, in my
> opinion, is one of the major reasons why people who use Linux in
> embedded systems end up using very old versions.

Actually, the *real* reason embedded systems end up using old versions is
much simpler.

They start developing their code on release 2.X.Y, and they keep their code
out-of-tree.  Then, when they come up for air, and it's at 2.X.(Y+15), they
discover that we weren't kidding when we shipped stable_api_nonsense.txt,
and since their code isn't in the tree, they have to do all the API cleanup
themselves, because no flock of nit-picking kernel janitor monkeys swarmed
over their code and magically fixed it up for them.

And unless Y+15 has some *very* compelling reasons to move forward, just
sticking at Y suddenly starts looking very good, because watching somebody
else's kernel janitor monkeys fix your code is fairly cheap, but paying your
own kernel janitor monkeys gets expensive really fast....


--==_Exmh_1171613989_6166P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF1WklcC3lWbTT17ARAqjPAJ9dQn7pF07M88fRR5M7WbMgxpenXQCgmkEJ
OFR9UrEhXGVCiCH7TrwzpCc=
=doKV
-----END PGP SIGNATURE-----

--==_Exmh_1171613989_6166P--

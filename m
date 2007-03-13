Return-Path: <linux-kernel-owner+w=401wt.eu-S1161035AbXCMRVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161035AbXCMRVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 13:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161038AbXCMRVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 13:21:53 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55459 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161044AbXCMRVw (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 13:21:52 -0400
Message-Id: <200703131721.l2DHLDjV009580@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
In-Reply-To: Your message of "Mon, 12 Mar 2007 20:06:43 BST."
             <1173726403.9153.5.camel@bip.parateam.prv>
From: Valdis.Kletnieks@vt.edu
References: <200703111457.17624.kernel@kolivas.org> <200703122223.07048.kernel@kolivas.org> <1173710082.6326.49.camel@Homer.simpson.net> <200703130549.47058.kernel@kolivas.org>
            <1173726403.9153.5.camel@bip.parateam.prv>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1173806473_3149P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Mar 2007 13:21:13 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1173806473_3149P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Mar 2007 20:06:43 BST, Xavier Bestel said:
> Le mardi 13 mars 2007 =E0 05:49 +1100, Con Kolivas a =E9crit :
> > Again I think your test is not a valid testcase. Why use two threads =
for your=20
> > encoding with one cpu? Is that what other dedicated desktop OSs would=
 do?
>=20
> One thought occured to me (shit happens, sometimes): as your scheduler
> is =22strictly fair=22, won't that enable trivial DoS by just letting a=
n
> user fork a multitude of CPU-intensive processes ?

Fork bombs are the reason that 'ulimit -u' exists. I don't see this sched=
uler
as being significantly more DoS'able via that route than previous schedul=
ers.

--==_Exmh_1173806473_3149P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF9t2JcC3lWbTT17ARArqBAKCLGF5KbFKNHUfLDMYV7mEWqAYmNACgp4GJ
vVZJgQepswpfw5OKuRf8KFU=
=7pVN
-----END PGP SIGNATURE-----

--==_Exmh_1173806473_3149P--

Return-Path: <linux-kernel-owner+w=401wt.eu-S966071AbXDGQTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966071AbXDGQTV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966076AbXDGQTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:19:21 -0400
Received: from h80ad275a.async.vt.edu ([128.173.39.90]:42044 "EHLO
	h80ad275a.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966071AbXDGQTU (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:19:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Ken Chen <kenchen@google.com>,
       Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] remove artificial software max_loop limit
In-Reply-To: Your message of "Fri, 06 Apr 2007 16:33:32 EDT."
             <4616AE9C.9060400@tmr.com>
From: Valdis.Kletnieks@vt.edu
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com> <b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com> <Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr> <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com> <20070330141524.5f6cff29.akpm@linux-foundation.org> <460FE380.2050608@slax.org> <460FE478.9070901@slax.org> <b040c32a0704011110n639d6ea4h447646b6da92974e@mail.gmail.com> <Pine.LNX.4.61.0704012106010.16977@yvahk01.tjqt.qr>
            <4616AE9C.9060400@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175962732_4736P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 07 Apr 2007 12:18:52 -0400
Message-ID: <11158.1175962732@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175962732_4736P
Content-Type: text/plain; charset=us-ascii

On Fri, 06 Apr 2007 16:33:32 EDT, Bill Davidsen said:
> Jan Engelhardt wrote:

> > Who cares if the user specifies max_loop=8 but still is able to open up 
> > /dev/loop8, loop9, etc.? max_loop=X basically meant (at least to me) 
> > "have at least X" loops ready.
> > 
> You have just come up with a really good reason not to do unlimited 
> loops.

That, and I'd expect the intuitive name for "have at least N ready" to
be 'min_loop=N'.  'max_loop=N' means (to me, at least) "If I ask for N+1,
something has obviously gone very wrong, so please shoot my process before
it gets worse".

Maybe what's needed is *both* a max_ and min_ parameter?

--==_Exmh_1175962732_4736P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGF8RscC3lWbTT17ARAoL4AJ9ZTtIA7mWcYoiyEZcB33E3MKPfBwCfbAaf
vZjivbjNfbNUu4Cp0+GvVzo=
=o8rc
-----END PGP SIGNATURE-----

--==_Exmh_1175962732_4736P--

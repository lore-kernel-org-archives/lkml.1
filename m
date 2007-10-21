Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbXJUEyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbXJUEyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 00:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbXJUEyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 00:54:07 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59519 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbXJUEyD (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 00:54:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Al Boldi <a1426z@gawab.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Patrick McHardy <kaber@trash.net>,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFD] iptables: mangle table obsoletes filter table
In-Reply-To: Your message of "Sun, 21 Oct 2007 07:31:58 +0300."
             <200710210731.58959.a1426z@gawab.com>
From: Valdis.Kletnieks@vt.edu
References: <200710120031.42805.a1426z@gawab.com> <200710200640.02012.a1426z@gawab.com> <26556.1192855654@turing-police.cc.vt.edu>
            <200710210731.58959.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1192942439_3691P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 21 Oct 2007 00:53:59 -0400
Message-ID: <26984.1192942439@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1192942439_3691P
Content-Type: text/plain; charset=us-ascii

On Sun, 21 Oct 2007 07:31:58 +0300, Al Boldi said:
> > Well, for example to stop any transient packets being forwarded.  You could 
> > probably hack around this using mark's, but you can't stop the implied
> > route lookup, unless you stop it in prerouting.
> 
> Basically, you have one big unintended gaping whole in your firewall, that 
> could easily be exploited for DoS attacks at the least, unless you put in 
> specific rules to limit this.

OK, the light bulb just went on... ;)

We actually *do* have an issue with the flip side of that - it's a frikking
pain to make packets that show up on eth0 with a destination of 127.0.0.1
go away un-noticed - or at least I'm assuming it's the flip side of the same
issue.

--==_Exmh_1192942439_3691P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHGttncC3lWbTT17ARAisTAKCHiAcF87qCKjCKtrQ2DNnYRVB80QCg3Qhy
GkVtjY0WchJuTHYb/VNnF2c=
=O+mL
-----END PGP SIGNATURE-----

--==_Exmh_1192942439_3691P--

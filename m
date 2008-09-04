Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYIDVCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYIDVCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbYIDVB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:01:58 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40544 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbYIDVB5 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:01:57 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: Your message of "Thu, 04 Sep 2008 17:36:20 +0200."
             <20080904153620.GC7120@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <20080904150339.896115280@linutronix.de>
            <20080904153620.GC7120@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1220562057_3385P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Sep 2008 17:00:57 -0400
Message-ID: <116316.1220562057@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1220562057_3385P
Content-Type: text/plain; charset=us-ascii

On Thu, 04 Sep 2008 17:36:20 +0200, Ingo Molnar said:

> i've added them to tip/x86/tsc and merged it into tip/master - if 
> there's test success we can merge it into x86/urgent as well and push it 
> into v2.6.27. Any objections to that merge route?

Timekeeping has always been a snarly issue fraught with peril when testing on
new hardware.  Are we confident enough that this will DTRT on almost every
platform, including all the busticated ones?  Seems dangerous to be merging
it for .27 when we're already past -rc5.

But if Ingo and Thomas want to merge it, it's OK with me as long as they
take the blame for it. :)


--==_Exmh_1220562057_3385P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIwEyJcC3lWbTT17ARAogqAJ43DiqotPwRzeHLjVHCjJ5ZpZ8qmwCgxzBv
dbjTeF15mB7pzDW0a1kiojg=
=zH/E
-----END PGP SIGNATURE-----

--==_Exmh_1220562057_3385P--

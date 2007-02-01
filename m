Return-Path: <linux-kernel-owner+w=401wt.eu-S1422983AbXBAUSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422983AbXBAUSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 15:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422980AbXBAUSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 15:18:14 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51929 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422983AbXBAUSN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 15:18:13 -0500
Message-Id: <200702012017.l11KHBG7026805@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tim Schmielau <tim@physik3.uni-rostock.de>
Cc: David Howells <dhowells@redhat.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
In-Reply-To: Your message of "Thu, 01 Feb 2007 13:39:15 +0100."
             <Pine.LNX.4.63.0702011336490.15668@gockel.physik3.uni-rostock.de>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6> <3565.1170326639@redhat.com>
            <Pine.LNX.4.63.0702011336490.15668@gockel.physik3.uni-rostock.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1170361031_24539P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Feb 2007 15:17:11 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1170361031_24539P
Content-Type: text/plain; charset=us-ascii

On Thu, 01 Feb 2007 13:39:15 +0100, Tim Schmielau said:
> #define is_power_of_4(x) (is_power_of_2_or_zero(x) \
>                           && (x & ((typeof(x))0x55555555)))

Those 5's are going to need more magic if x is a 64-bit typeof?


--==_Exmh_1170361031_24539P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFFwkrHcC3lWbTT17ARAu1jAJ0ZqLcIaS4z0OUf0ERqr0cTqy0OPQCdEced
fbW0FRvtj2AGQwC88LlHEq0=
=+gKA
-----END PGP SIGNATURE-----

--==_Exmh_1170361031_24539P--

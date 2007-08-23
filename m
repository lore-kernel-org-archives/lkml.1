Return-Path: <linux-kernel-owner+w=401wt.eu-S1765709AbXHWUll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765709AbXHWUll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765475AbXHWUl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:41:29 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52156 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765379AbXHWUl2 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:41:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Hirokazu Takata <takata@linux-m32r.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>,
       akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       Chris Snook <csnook@redhat.com>, Chris Friesen <cfriesen@nortel.com>
Subject: Re: [PATCH 11/23] make atomic_read() and atomic_set() behavior consistent on m32r
In-Reply-To: Your message of "Thu, 23 Aug 2007 21:29:41 +0200."
             <e8b5ee6194ed619c245eb884c5ae6b11@kernel.crashing.org>
From: Valdis.Kletnieks@vt.edu
References: <46C03885.7000109@redhat.com> <20070813112452.GK24018@shell.boston.redhat.com> <swfhcmswcux.wl%takata.hirokazu@renesas.com> <swfejhww4cs.wl%takata.hirokazu@renesas.com> <46CC42EF.3030602@redhat.com> <8fc86c23579e12b012891d6e69b1b107@kernel.crashing.org> <alpine.LFD.0.999.0708221116310.30176@woody.linux-foundation.org>
            <e8b5ee6194ed619c245eb884c5ae6b11@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187901648_3088P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Aug 2007 16:40:48 -0400
Message-ID: <20267.1187901648@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187901648_3088P
Content-Type: text/plain; charset=us-ascii

On Thu, 23 Aug 2007 21:29:41 +0200, Segher Boessenkool said:
> int f(atomic_t *x)
> {
>         return atomic_read(x) + atomic_read(x);
> }

>          ld r0,@r0
>          slli r0,#1
>          jmp lr

Looks like peephole optimization at work.

--==_Exmh_1187901648_3088P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGzfDQcC3lWbTT17ARAiesAKCt9DXTeV4fcq6jVhYUSt1B15F98gCfV5ig
WNElhd+utJOGg504suZT3t4=
=aRpd
-----END PGP SIGNATURE-----

--==_Exmh_1187901648_3088P--

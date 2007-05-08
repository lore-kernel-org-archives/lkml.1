Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbXEHUWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbXEHUWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbXEHUWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:22:38 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43499 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbXEHUWh (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:22:37 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: Lockup after logging out of X
In-Reply-To: Your message of "Tue, 08 May 2007 20:51:42 BST."
             <20070508195142.GA30030@deepthought>
From: Valdis.Kletnieks@vt.edu
References: <20070508195142.GA30030@deepthought>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178655711_4120P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 08 May 2007 16:21:51 -0400
Message-ID: <16635.1178655711@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178655711_4120P
Content-Type: text/plain; charset=us-ascii

On Tue, 08 May 2007 20:51:42 BST, Ken Moffat said:

>  After trying git-bisect, it tells me:
> 0dbf7028c0c1f266c9631139450a1502d3cd457e is first bad commit
> commit 0dbf7028c0c1f266c9631139450a1502d3cd457e
> Author: Vivek Goyal <vgoyal@in.ibm.com>
> Date:   Wed May 2 19:27:07 2007 +0200
> 
>     [PATCH] x86: __pa and __pa_symbol address space separation
> 
>     Currently __pa_symbol is for use with symbols in the kernel address
>     map and __pa is for use with pointers into the physical memory map.
>     But the code is implemented so you can usually interchange the two.

I saw this same exact problem on my box back at 21-rc5-mm4, but didn't
report it here because Christoph Hellwig thinks such things are off-topic (as
I was seeing it with the NVidia driver).

http://marc.info/?l=linux-kernel&m=117579249300455&w=2
http://www.nvnews.net/vbulletin/showthread.php?t=89444

Sorry to see you hit a problem with the exact same patch with a Radeon card
a month later.





--==_Exmh_1178655711_4120P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGQNvfcC3lWbTT17ARArDDAKCmsf+eQ8ePqdo7Q45FC+cAIN1s8QCeLWkQ
hhWXdEuhazc2ac4aKI8BSrY=
=jcLD
-----END PGP SIGNATURE-----

--==_Exmh_1178655711_4120P--

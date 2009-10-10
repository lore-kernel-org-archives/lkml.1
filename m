Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbZJJSL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbZJJSL3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 14:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762060AbZJJSL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 14:11:28 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41867 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762043AbZJJSL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 14:11:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Byron Stanoszek <bstanoszek@comtime.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
In-Reply-To: Your message of "Sat, 10 Oct 2009 00:28:42 +0800."
             <b6a2187b0910090928r648169dax86178a3e8b8c2f21@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com> <alpine.LFD.2.01.0910051110200.3432@localhost.localdomain> <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com> <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain> <b6a2187b0910052312o662642b2teded3d19548b9151@mail.gmail.com> <alpine.LFD.2.01.0910060731190.3432@localhost.localdomain>
            <b6a2187b0910090928r648169dax86178a3e8b8c2f21@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1255198236_250202P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 10 Oct 2009 14:10:36 -0400
Message-ID: <32059.1255198236@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.38.202 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4AD0CE1E.0028,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1255198236_250202P
Content-Type: text/plain; charset=us-ascii

On Sat, 10 Oct 2009 00:28:42 +0800, Jeff Chua said:

> From all the reading I've read about how slow 64-bit was, after doing all
> the lean and mean compiling, 64-bit is definitely the way to go! Fast and
> worth every bit switching to 64-bit! Now I can go for 128GB ram.

When the MIPS, PowerPC, and Sparc architectures went from 32 to 64 bits,
they *did* take a bit of a performance hit because it basically doubled
the memory bandwidth usage.  However, they all had a reasonably large
number of registers in 32-bit mode.  When the x86 went 64-bit, the register
pressure relief from the additional registers usually more then outweighs
the additional memory bandwidth (basically, if you're spending twice as
much time on each load/store, but only doing it 40% as often, you come out
ahead...)

--==_Exmh_1255198236_250202P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK0M4ccC3lWbTT17ARAlReAJ9Uc47tfas43Q8Af6xB2GuCY+8RGgCfXXuI
Gsb9UdbOiDqN3xeNDCExOVc=
=2Md7
-----END PGP SIGNATURE-----

--==_Exmh_1255198236_250202P--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbZABQ1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbZABQ1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757159AbZABQ0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:26:54 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51246 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035AbZABQ0x (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:26:53 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: david@lang.hm
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Bryan Donlan <bdonlan@gmail.com>,
       Ingo Brueckl <ib@wupperonline.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86 (Linux Tiny): configure out support for some processors
In-Reply-To: Your message of "Fri, 02 Jan 2009 08:51:28 PST."
             <alpine.DEB.1.10.0901020849180.20509@asgard.lang.hm>
From: Valdis.Kletnieks@vt.edu
References: <495d2974@wupperonline.de> <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com> <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com> <20090102093801.GD1975@elte.hu> <3f9a31f40901020710h508bbfbch3d7ccd6f4898ea03@mail.gmail.com> <11444.1230910752@turing-police.cc.vt.edu>
            <alpine.DEB.1.10.0901020849180.20509@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1230913598_3517P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Jan 2009 11:26:38 -0500
Message-ID: <14241.1230913598@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1230913598_3517P
Content-Type: text/plain; charset=us-ascii

On Fri, 02 Jan 2009 08:51:28 PST, david@lang.hm said:
> having things outside of the embedded menu depend on embedded makes it 
> hard for people to figure out what they need to do to disable specific 
> things.

Odd, I can do a 'make menuconfig', do a /EARLY_PRINTK, and see:

 Symbol: EARLY_PRINTK [=y]                                               x  
  x Prompt: Early printk                                                    x  
  x   Defined at arch/x86/Kconfig.debug:33                                  x  
  x   Depends on: EMBEDDED                                                  x  
  x   Location:                                                             x  
  x     -> Kernel hacking

> if you follow the logic you are providing to it's logical conclusion you 
> may as well put all kernel config options under "I really know what I'm 
> doing" top level lockout

Hey, I didn't make up that logic. ;)

A large percentage of the kernel config options are things that really *could*
be one way or the other for any given system.  Maybe you want ext4, maybe you
don't.  Maybe you need process accounting, maybe you don't.  So they don't go
under EMBEDDED.  But we can be 98% sure that they probably want PRINTK.


--==_Exmh_1230913598_3517P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJXkA+cC3lWbTT17ARAs2VAKC8mEid6hi8ibWM08wRnwE+uWZLoQCbBodM
mzKz71QUgvyKkd1fkMOm+Qk=
=w4Wl
-----END PGP SIGNATURE-----

--==_Exmh_1230913598_3517P--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbXJIUrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbXJIUrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 16:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbXJIUq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 16:46:58 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58575 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbXJIUq5 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 16:46:57 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Andi Kleen <andi@firstfloor.org>,
       Christoph Egger <Christoph.Egger@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i386: mce cleanup part1: functional change
In-Reply-To: Your message of "Tue, 09 Oct 2007 18:32:30 +0200."
             <20071009163230.GC22435@flower.upol.cz>
From: Valdis.Kletnieks@vt.edu
References: <11919341961890-git-send-email-joerg.roedel@amd.com> <11919341961530-git-send-email-joerg.roedel@amd.com> <E1IfHZg-0003dp-FA@flower> <20071009160605.GC13205@amd.com>
            <20071009163230.GC22435@flower.upol.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191962806_2838P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Oct 2007 16:46:46 -0400
Message-ID: <1152.1191962806@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191962806_2838P
Content-Type: text/plain; charset=us-ascii

On Tue, 09 Oct 2007 18:32:30 +0200, Oleg Verych said:
> On Tue, Oct 09, 2007 at 06:06:05PM +0200, Joerg Roedel wrote:
> > > cpu_has() returns int,
> > > but would it be better to have something like
> > > 
> > >   	if (!mce_disabled &&
> > > 	    !(c->x86_capability & (X86_FEATURE_MCA | X86_FEATURE_MCE)) {
> > > 		printk(KERN_INFO "CPU%i: No machine check support available\n",
> > > 			smp_processor_id());
> > 
> > This looks complicated and is harder to read. Its exactly the purpose of the
> > cpu_has() macro to avoid such constructs.
> 
> It is done via test_bit(), which is designed for IO access with all that
> `const volatile' stuff, 2 x unnecessary, can't be optimized here (IMHO).

If this code is getting called often enough that optimization matters, you
got *bigger* issues to worry about than optimization.  Looks like it should
only happen once at boot time.

--==_Exmh_1191962806_2838P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHC+i2cC3lWbTT17ARAu43AJ0T94XZXqfyA/ozz2GfjN+0XcWJHwCgw+uO
ZX+xTeEr8S9nQJ7m1RXhoOI=
=Nzz4
-----END PGP SIGNATURE-----

--==_Exmh_1191962806_2838P--

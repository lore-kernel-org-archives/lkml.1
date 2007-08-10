Return-Path: <linux-kernel-owner+w=401wt.eu-S941445AbXHJQld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941445AbXHJQld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935183AbXHJQlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:41:15 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41012 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939707AbXHJQlN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:41:13 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
In-Reply-To: Your message of "Fri, 10 Aug 2007 11:23:34 +0200."
             <20070810092334.GA15285@hall.aurel32.net>
From: Valdis.Kletnieks@vt.edu
References: <20070809224254.11f42716.akpm@linux-foundation.org>
            <20070810092334.GA15285@hall.aurel32.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1186764049_6376P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 10 Aug 2007 12:40:49 -0400
Message-ID: <26090.1186764049@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1186764049_6376P
Content-Type: text/plain; charset=us-ascii

On Fri, 10 Aug 2007 11:23:34 +0200, Aurelien Jarno said:
> I have just tried it, and it fails to build for MIPS with the following
> error:
> 
>   CC      arch/mips/kernel/asm-offsets.s
> In file included from include/linux/sched.h:58,
>                  from arch/mips/kernel/asm-offsets.c:13:
> include/linux/mm_types.h:115: error: expected specifier-qualifier-list before 'pgprot_t'
> include/linux/mm_types.h:169: warning: 'struct file' declared inside parameter list
> include/linux/mm_types.h:169: warning: its scope is only this definition or declaration, which is probably not what you want
> include/linux/mm_types.h:175: error: expected specifier-qualifier-list before 'pgd_t'
> 
> 
> The trivial patch below fixes this problem.

Rather than adding it to an include/linux file, where it then gets dragged
in on *all* architectures, maybe we should investigate why it dies on MIPS,
and fix it for *that* arch?

--==_Exmh_1186764049_6376P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGvJURcC3lWbTT17ARAlurAKD2/PI4ff6hhTtm/OT/cBmuLpf5kQCgtcDQ
JmmxHucUInsjRbeDlOjVVoo=
=BQQH
-----END PGP SIGNATURE-----

--==_Exmh_1186764049_6376P--

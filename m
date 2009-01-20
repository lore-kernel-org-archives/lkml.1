Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbZATDgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbZATDgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 22:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZATDf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 22:35:58 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54115 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbZATDf5 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 22:35:57 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Avuton Olrich <avuton@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due to dc1e35c
In-Reply-To: Your message of "Mon, 19 Jan 2009 13:57:36 PST."
             <20090119215736.GE31356@linux-os.sc.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com> <4974CC8B.1030403@zytor.com> <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com> <4974DD86.2090300@zytor.com> <20090119201115.GD31356@linux-os.sc.intel.com> <3aa654a40901191346i12cc736m40bebd422100a088@mail.gmail.com>
            <20090119215736.GE31356@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1232422525_3870P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Jan 2009 22:35:25 -0500
Message-ID: <85492.1232422525@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1232422525_3870P
Content-Type: text/plain; charset=us-ascii

On Mon, 19 Jan 2009 13:57:36 PST, Suresh Siddha said:

> Though the bios is the culprit and this option will severely limit
> the cpu capabilities that OS can take advantage of, OS should fallback
> to a safer mode. I will have a patch for it.
> 
> Also, I wonder, if we should complain/scream during boot if we find only
> fewer cpuid levels on modern generation cpu's.

I think a KERN_INFO "Core2 E9700 expected 6 cpuid levels, got 4"
would possibly be a good idea.

Might be a good idea to check what happens under VMWare and similar though, it
looks like the type of thing a hypervisor is likely to do something odd to us...

--==_Exmh_1232422525_3870P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJdUZ9cC3lWbTT17ARAgG5AKD8CaejNRq+QCAy1gtuGzyULF3bigCePeSp
tjJy44vJ2Uso3zq5fEd/oUA=
=8+34
-----END PGP SIGNATURE-----

--==_Exmh_1232422525_3870P--

Return-Path: <linux-kernel-owner+w=401wt.eu-S933049AbXFRVux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049AbXFRVux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763296AbXFRVuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:50:46 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51502 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762553AbXFRVup (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:50:45 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch-mm 00/25] High resolution timer updates and x86_64 support - V2
In-Reply-To: Your message of "Mon, 18 Jun 2007 13:24:33 PDT."
             <653FFBB4508B9042B5D43DC9E18836F501091308@scsmsx415.amr.corp.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <653FFBB4508B9042B5D43DC9E18836F501091308@scsmsx415.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1182203384_14795P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Jun 2007 17:49:44 -0400
Message-ID: <18748.1182203384@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1182203384_14795P
Content-Type: text/plain; charset=us-ascii

On Mon, 18 Jun 2007 13:24:33 PDT, "Pallipadi, Venkatesh" said:

> >state2/time: -159524787
> >state2/usage: 15007443
> >
> 
> The problem is powertop only understands /proc/acpi/processor/CPU*/power
> for
> and not /sys..cpuidle for the moment.
> 
> I had a patch in recent cpuidle fixes series that makes /proc interface
> active
> again with cpuidle which should correct this. Those patches are not in
> rc4-mm2-hrt4, but are there in latest rc4-hrt and rc5-hrt series.

OK, so I've got a 32/64 bug that isn't the cause of *this* issue because
powertop isn't looking at the broken value.

A quick check shows that the keep_proc_acpi_power_around_001.patch from
rc5-hrt will apply to rc4-mm2-hrt - I'll give that a try tonight and report
back...


--==_Exmh_1182203384_14795P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGdv33cC3lWbTT17ARAsgHAJ9jmDPFMHYwplmukdbEGijE1UXfogCfZG+M
vDGt35pShodNiVKNnZv0htM=
=JEk2
-----END PGP SIGNATURE-----

--==_Exmh_1182203384_14795P--

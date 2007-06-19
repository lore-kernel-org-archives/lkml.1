Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbXFSL3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbXFSL3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 07:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758294AbXFSL3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 07:29:00 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37902 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852AbXFSL26 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 07:28:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch-mm 00/25] High resolution timer updates and x86_64 support - V2
In-Reply-To: Your message of "Mon, 18 Jun 2007 17:49:44 EDT."
             <18748.1182203384@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <653FFBB4508B9042B5D43DC9E18836F501091308@scsmsx415.amr.corp.intel.com>
            <18748.1182203384@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1182252484_7043P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 19 Jun 2007 07:28:04 -0400
Message-ID: <15083.1182252484@turing-police.cc.vt.edu>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1182252484_7043P
Content-Type: text/plain; charset=us-ascii

On Mon, 18 Jun 2007 17:49:44 EDT, Valdis.Kletnieks@vt.edu said:

> A quick check shows that the keep_proc_acpi_power_around_001.patch from
> rc5-hrt will apply to rc4-mm2-hrt - I'll give that a try tonight and report
> back...

Confirming - I backported that patch from rc5-hrt to rc4-mm2-hrt, and
now powertop is reporting sane values again:

     PowerTOP version 1.7       (C) 2007 Intel Corporation

Cn          Avg residency (5s)          P-states (frequencies)
C0 (cpu running)        (15.8%)
C1                0.0ms ( 0.0%)         2.00 Ghz     0.0%
C2                0.6ms ( 7.9%)         1.67 Ghz     0.0%
C3                0.7ms (76.3%)         1333 Mhz     0.0%
                                        1000 Mhz   100.0%



--==_Exmh_1182252484_7043P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGd73EcC3lWbTT17ARAlj4AKDhrMmi+vBb2vUBAOMprz1l0Vm/+wCfXZ9i
SEmSBv5PJkcl3H8dPZSQiwc=
=fx8A
-----END PGP SIGNATURE-----

--==_Exmh_1182252484_7043P--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067Ab0ALQSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0ALQSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000Ab0ALQSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:18:05 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:56544 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab0ALQSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:18:04 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] x86: use dmi check to treat disabled cpus as hotplug cpus.
In-Reply-To: Your message of "Mon, 11 Jan 2010 19:13:32 PST."
             <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org> <1263264483-3959-4-git-send-email-yinghai@kernel.org>
            <alpine.LFD.2.00.1001111906300.17145@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1263312874_4706P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 12 Jan 2010 11:14:34 -0500
Message-ID: <6686.1263312874@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4B4C9FEA.0353,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1263312874_4706P
Content-Type: text/plain; charset=us-ascii

On Mon, 11 Jan 2010 19:13:32 PST, Linus Torvalds said:

>  - only use that flat apic mode when you _know_ that you absolutely will 
>    never have more than 8 cpu's. Ie when CONFIG_NR_CPUS <= 8 (or, with 
>    1/3, when nr_cpu_ids <= 8) and/or when <= 8 CPU's were detected, and 
>    CPU hotplug is disabled entirely.

OK, I'll bite - how do you build an X86-64 kernel that doesn't have
CONFIG_HOTPLUG_CPU selected?  Try as I might, even if I have PM_SLEEP=n,
PM_SLEEP_SMP insists on being set, and then selecting HOTPLUG_SMP.  For the
record, I do *not* need/desire S2R, S2D, 'suspend', or similar functionality.

Is there some subtle reason why PM_SLEEP_SMP has to be on even without PM_SLEEP?


--==_Exmh_1263312874_4706P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLTJ/qcC3lWbTT17ARAvSwAJ9VUuyaYtmARNTSkQNNilNz6IIg4wCePIzz
HdHs/+ywidesaqODOi0U8IY=
=LdeI
-----END PGP SIGNATURE-----

--==_Exmh_1263312874_4706P--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761166AbXEPJ7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761166AbXEPJ7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbXEPJ66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:58:58 -0400
Received: from www.osadl.org ([213.239.205.134]:52098 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754139AbXEPJ66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:58:58 -0400
Subject: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v5
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frank Sorenson <frank@tuxrocks.com>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>
In-Reply-To: <1178485128.31213.98.camel@localhost.localdomain>
References: <1178485128.31213.98.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 16 May 2007 12:03:09 +0200
Message-Id: <1179309789.3764.20.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pleased to announce an updated version of the x86_64 highres/dyntick
support patches against 2.6.22-rc1:

http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v5.patch

Broken out version is available here:
http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v5.patches.tar.bz2

Changes since the last version:

- Enforced enabling of HPET (Venki Pallipadi)
	Detects and enables HPET on Intel ICHx chipsets, when the BIOS
	hides it.

	Venki, great work, thanks !

- Another variant of PIT wreckage fixup
	Frank, does this one work for you ?

- Various fixlets (me)

Comments, bugreports, patches are welcome as usual

Thanks,

        tglx



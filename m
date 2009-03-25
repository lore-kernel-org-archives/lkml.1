Return-Path: <linux-kernel-owner+w=401wt.eu-S1763841AbZCYSnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763841AbZCYSnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZCYSnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:43:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60241 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbZCYSni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:43:38 -0400
Date: Wed, 25 Mar 2009 19:42:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Lutomirski <amluto@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Mark Gross <mgross@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu)
	enabled
Message-ID: <20090325184229.GA6117@elte.hu>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com> <20090324203259.GC26930@elte.hu> <1238003581.2085.53.camel@macbook.infradead.org> <20090325175908.GA25518@elte.hu> <1238004228.2085.56.camel@macbook.infradead.org> <20090325180720.GA28366@elte.hu> <1238004601.2085.57.camel@macbook.infradead.org> <20090325182003.GC28366@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325182003.GC28366@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., there's also the bugreport below.

	Ingo

http://bugzilla.kernel.org/show_bug.cgi?id=12940

           Summary: CONFIG_DMAR/CONFIG_DMAR_DEFAULT_ON makes the kernel
                    unbootable
           Product: Platform Specific/Hardware
           Version: 2.5
    Kernel Version: 2.6.29
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: x86-64
        AssignedTo: platform_x86_64@kernel-bugs.osdl.org
        ReportedBy: edman007x@mac.com
        Regression: No


When i enable the options CONFIG_DMAR/CONFIG_DMAR_DEFAULT_ON my kernel fails to
boot. It just hangs at:

hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter

right before that i see stuff saying that the IOMMU was remapping stuff. When i
encountered this i recompiled the kernel, disabled only
CONFIG_DMAR/CONFIG_DMAR_DEFAULT_ON and my kernel worked fine.


My hardware:
Tyan i5400PW/ 2x E5410 CPUs (latest BIOS)
8GB RAM
ATI radeonhd 3870
3ware 9650se

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug.

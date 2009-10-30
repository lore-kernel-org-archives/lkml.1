Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbZJ3S0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbZJ3S0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 14:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932796AbZJ3S0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 14:26:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:48694 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932790AbZJ3S0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 14:26:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,655,1249282800"; 
   d="scan'208";a="742325950"
Subject: Re: [patch 0/6] x86: cleanups and fixes for irq migration code
 during cpu offline
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "garyhade@us.ibm.com" <garyhade@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091026222430.313656103@sbs-t61.sc.intel.com>
References: <20091026222430.313656103@sbs-t61.sc.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 30 Oct 2009 11:25:29 -0800
Message-Id: <1256930729.2679.10.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 15:24 -0700, Siddha, Suresh B wrote:
> First four patches in the series unify the fixup_irqs() along with
> couple of cleanups. It also fixes an issue where the interrupt subsystem can 
> point the interrupt to the offlined cpu (for non interrupt-remapping case)
> causing the device to not work. This was observed by Gary.
> 
> These four patches are ready for inclusion

Ingo, if no one has any objections, can you please consider the first
four patches in this patchset for -tip testing?

> and while there was a debate
> in the past that fixup_irqs() is kind of broken (because of migrating
> interrupts in the process context for non intr-remapping platforms)
> we think that these patches enhance the existing code and not introduce any
> more new races.
> 
> The last two patches in the series are titled as RFC. 

Eric, any thoughts on these two RFC patches or the other 4 patches that
are ready to go.

> These patches
> address removing the local_irq_enable()/local_irq_disable() in
> the fixup_irqs(). All the patches (including these last two RFC patches) are
> tested on Intel platforms (by myself) and on AMD platforms(by Gary).
> 
> We labeled the last two patches as RFC mainly because they need more testing and
> thoughts from Eric and others who did some unsuccessful experiments in this
> area (migrating irq in the process context for non intr-remapping platforms)
> before.

thanks,
suresh


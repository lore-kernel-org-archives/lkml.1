Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbZHUC3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbZHUC3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 22:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZHUC3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 22:29:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:9699 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbZHUC3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 22:29:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,248,1249282800"; 
   d="scan'208";a="719074816"
Subject: Re: [PATCH -v6 for 2.6.32] x86: MCE: Re-implement MCE log ring
 buffer as per-CPU ring buffer
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A8DFB3F.40309@jp.fujitsu.com>
References: <1250736679.5337.540.camel@yhuang-dev.sh.intel.com>
	 <4A8DFB3F.40309@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 10:29:43 +0800
Message-Id: <1250821783.5337.574.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 09:41 +0800, Hidetoshi Seto wrote:
> Huang Ying wrote:
> > Re-implement MCE log ring buffer as per-CPU ring buffer for better
> > scalability.
> > 
> (snip)
> > ChangeLog:
> > 
> > v6:
> > 
> > - Rebased on latest x86-tip.git/x86/mce + x86/tip
> 
> Does this mean your patch is based on a local branch you merged?
> Why not on tip/x86/mce alone as usual?
> What branch are you requesting this patch to be applied to?

Re-checked again. The patch can be applied to x86/mce, with only one not
important "fuzzy 1" warning.

Best Regards,
Huang Ying


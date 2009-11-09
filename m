Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbZKII6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbZKII6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZKII6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:58:34 -0500
Received: from mga05.intel.com ([192.55.52.89]:25359 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754623AbZKII6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:58:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,706,1249282800"; 
   d="scan'208";a="745122123"
Date: Mon, 9 Nov 2009 16:31:46 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86: under bios control, restore AP's APIC_LVTTHMR
	to the BSP value
Message-ID: <20091109083146.GA3484@ywang-moblin2.bj.intel.com>
References: <20091109042134.GA9169@ywang-moblin2.bj.intel.com> <20091109070844.GA453@elte.hu> <20091109072528.GA2646@ywang-moblin2.bj.intel.com> <20091109075957.GH453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109075957.GH453@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 08:59:57AM +0100, Ingo Molnar wrote:
> 
> That's true in Linus's tree but Boris Petkov fixed the MCE init 
> functions naming mess in the x86 tree, in these commits:
> 
>  b33a636: x86, mce: Add a global MCE init helper
>  5e09954: x86, mce: Fix up MCE naming nomenclature
> 
> Please base your patch on:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> to have the latest MCE code. So if you stick that init function into 
> mcheck_init() in -tip it should be called once per bootup only. (I have 
> not checked the other boot dependencies, please do that.)
> 

By the time mcheck_init() executes, intel_init_thermal() has finished
running on BSP. Any suggestions on how to resolve this issue?

Thanks for your insights!
-Yong

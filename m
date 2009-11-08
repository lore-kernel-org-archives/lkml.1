Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZKHNEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZKHNEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZKHNEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:04:51 -0500
Received: from mga05.intel.com ([192.55.52.89]:43258 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751411AbZKHNEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:04:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,703,1249282800"; 
   d="scan'208";a="744929266"
Date: Sun, 8 Nov 2009 20:38:12 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Yong Wang <yong.y.wang@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, therm: Only read the initial value of thermal LVT
	entry on BSP
Message-ID: <20091108123812.GA877@ywang-moblin2.bj.intel.com>
References: <20091107001736.GA30790@ywang-moblin2.bj.intel.com> <1257562565.4083.485.camel@sbs-t61.sc.intel.com> <20091108102520.GC7233@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108102520.GC7233@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 11:25:21AM +0100, Ingo Molnar wrote:
> 
> i dont disagree with the fix, but could we please do it a bit cleaner, 
> and initialize a proper file-scope lvtthrm_init value from a different 
> boot-CPU-only function? (not intel_init_thermal)
> 

Thanks for your comments. Just want to make sure I understand correctly.
By 'file-scope', do you want me to define lvtthrm_init as a static
variable but not to define it in any function?

> that makes it cleaner, and also it will work if we dont boot on cpu==0. 
> (should that ever occur)
> 

May I know when will this happen?

Thanks
-Yong

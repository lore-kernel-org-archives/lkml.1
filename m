Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbZCaEa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbZCaEa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 00:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbZCaEas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 00:30:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:14366 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZCaEas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 00:30:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,450,1233561600"; 
   d="scan'208";a="443498084"
Message-Id: <20090331042208.063501000@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 21:22:08 -0700
From: fenghua.yu@intel.com
To: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Lutomirski <amluto@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Yinghai Lu <yinghai@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       IOMMU <iommu@lists.linux-foundation.org>
Subject: Re: [patch 0/4] Intel IOMMU Supspend/Resume Support  
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> The attached patch set implements the suspend and resume feature for
>Intel
>> IOMMU. It hooks to kernel suspend and resume interface. When suspend
>happens, itsaves necessary hardware registers. When resume happens, it
>restores the
>> registers and restarts IOMMU.
>>
>> This patch set can be applied on the tip tree.
>
>Looks good to me, apart from the fact that your #4 patch actually needs
>to come before #1. Shall I apply it to my iommu-2.6.git tree or let Ingo
>take it? If the latter,
>
>Acked-by: David Woodhouse <David.Woodhouse@intel.com>
>Acked-by: David Woodhouse <David.Woodhouse@intel.com>
>Acked-by: David Woodhouse <David.Woodhouse@intel.com>
>Acked-by: David Woodhouse <David.Woodhouse@intel.com>
>
>(if you look carefully, you'll see those are in order 4, 1, 2, 3)
>
>Have we tested this on IA64?

Since ia64 platforms don't support suspend/resume, the code won't take action onia64. But it still installs unused sys device interface.

I'll clean up the code for ia64 and re-send the patch set.

Thanks.

-Fenghua

-- 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0BAEmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 23:42:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:35028 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0BAEmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 23:42:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,380,1262592000"; 
   d="scan'208";a="488601750"
Date: Mon, 1 Feb 2010 12:41:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com,
       haveblue@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, ak@linux.intel.com,
       hpa@kernel.org, haicheng.li@intel.com, shaohui.zheng@linux.intel.com
Subject: Re: [Patch - Resend v4] Memory-Hotplug: Fix the bug on interface
	/dev/mem for 64-bit kernel
Message-ID: <20100201044124.GA29097@localhost>
References: <20100201041253.GA1028@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201041253.GA1028@shaohui>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohui,

Some style nitpicks..

>  #ifdef CONFIG_MEMORY_HOTPLUG
> +/**

Should use /* here. 

> + * After memory hotplug, the variable max_pfn, max_low_pfn and high_memory will
> + * be affected, it will be updated in this function.
> + */
> +static inline void __meminit update_end_of_memory_vars(u64 start,

The "inline" and "__meminit" are both redundant here.

> +		max_low_pfn = max_pfn = end_pfn;

One assignment per line is preferred.

Thanks,
Fengguang


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbZLBMor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbZLBMor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZLBMoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:44:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39423 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbZLBMoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:44:46 -0500
Date: Wed, 2 Dec 2009 13:44:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/24] HWPOISON: add memory cgroup filter
Message-ID: <20091202124446.GA18989@one.firstfloor.org>
References: <20091202031231.735876003@intel.com> <20091202043046.519053333@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202043046.519053333@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> +static int hwpoison_filter_task(struct page *p)
> +{

Can we make that ifdef instead of depends on ?

-Andi
>  config HWPOISON_INJECT
> -	tristate "Poison pages injector"
> +	tristate "HWPoison pages injector"
>  	depends on MEMORY_FAILURE && DEBUG_KERNEL
> +	depends on CGROUP_MEM_RES_CTLR_SWAP

-- 
ak@linux.intel.com -- Speaking for myself only.

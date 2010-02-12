Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab0BLIEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 03:04:11 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44308 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab0BLIEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 03:04:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: tracking memory usage/leak in "inactive" field in /proc/meminfo?
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <4B7504D2.1040903@nortel.com>
References: <28c262361002111838q7db763feh851a9bea4fdd9096@mail.gmail.com> <4B7504D2.1040903@nortel.com>
Message-Id: <20100212170248.73B8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 12 Feb 2010 17:04:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   backtrace:
>     [<ffffffff8061c162>] kmemleak_alloc_page+0x1eb/0x380
>     [<ffffffff80276ae8>] __pagevec_lru_add_active+0xb6/0x104
>     [<ffffffff80276b85>] lru_cache_add_active+0x4f/0x53
>     [<ffffffff8027d182>] do_wp_page+0x355/0x6f6
>     [<ffffffff8027eef1>] handle_mm_fault+0x62b/0x77c
>     [<ffffffff80632557>] do_page_fault+0x3c7/0xba0
>     [<ffffffff8062fb79>] error_exit+0x0/0x51
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> and
> 
>   backtrace:
>     [<ffffffff8061c162>] kmemleak_alloc_page+0x1eb/0x380
>     [<ffffffff80276ae8>] __pagevec_lru_add_active+0xb6/0x104
>     [<ffffffff80276b85>] lru_cache_add_active+0x4f/0x53
>     [<ffffffff8027eddc>] handle_mm_fault+0x516/0x77c
>     [<ffffffff8027f180>] get_user_pages+0x13e/0x462
>     [<ffffffff802a2f65>] get_arg_page+0x6a/0xca
>     [<ffffffff802a30bf>] copy_strings+0xfa/0x1d4
>     [<ffffffff802a31c7>] copy_strings_kernel+0x2e/0x43
>     [<ffffffff802d33fb>] compat_do_execve+0x1fa/0x2fd
>     [<ffffffff8021e405>] sys32_execve+0x44/0x62
>     [<ffffffff8021def5>] ia32_ptregs_common+0x25/0x50
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> I'll dig into them further, but do either of these look like known issues?

no known issue.
AFAIK, 2.6.27 - 2.6.33 don't have such problem.



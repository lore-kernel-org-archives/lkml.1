Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbXGSG6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbXGSG6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 02:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbXGSG6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 02:58:38 -0400
Received: from fgwmail8.fujitsu.co.jp ([192.51.44.38]:46129 "EHLO
	fgwmail8.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbXGSG6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 02:58:36 -0400
Date: Thu, 19 Jul 2007 15:56:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, "tony.luck@intel.com" <tony.luck@intel.com>,
       nickpiggin@yahoo.com.au, mike@stroyan.net, Zoltan.Menyhart@bull.net,
       dmosberger@gmail.com, GOTO <y-goto@jp.fujitsu.com>
Subject: Re: [BUGFIX]{PATCH] flush icache on ia64 take2
Message-Id: <20070719155632.7dbfb110.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070706112901.16bb5f8a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070706112901.16bb5f8a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007 11:29:01 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> This is a patch for fixing icache flush race in ia64(Montecito) by implementing
> flush_icache_page() at el.
> 
> Changelog:
>  - updated against 2.6.22-rc7 (previous one was against 2.6.21)
>  - removed hugetlbe's lazy_mmu_prot_update().
>  - rewrote patch description.
>  - removed patch against mprotect() if flushes cache.
> 
Then, what should I do more for fixing this SIGILL problem ?

-Kame


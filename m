Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbYDCJjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbYDCJjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 05:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757424AbYDCJjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 05:39:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38541 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbYDCJjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 05:39:08 -0400
Date: Thu, 3 Apr 2008 18:43:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [-mm] Make the memory controller more desktop responsive
Message-Id: <20080403184351.42de4f56.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080403093253.8944.10168.sendpatchset@localhost.localdomain>
References: <20080403093253.8944.10168.sendpatchset@localhost.localdomain>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Apr 2008 15:02:53 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> This patch makes the memory controller more responsive on my desktop.
> 
> Here is what the patch does
> 
> 1. Reduces the number of retries to 2. We had 5 earlier, since we
>    were controlling swap cache as well. We pushed data from mappings
>    to swap cache and we needed additional passes to clear out the cache.

Hmm, what this change improves ?
I don't want to see OOM.

> 2. It sets all cached pages as inactive. We were by default marking
>    all pages as active, thus forcing us to go through two passes for
>    reclaiming pages
Agreed.

> 3. Removes congestion_wait(), since we already have that logic in
>    do_try_to_free_pages()
> 
Agreed.

Thanks,
-Kame


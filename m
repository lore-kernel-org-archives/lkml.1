Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbZGJCLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbZGJCLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 22:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZGJCL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 22:11:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35329 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZGJCL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 22:11:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <alpine.DEB.1.10.0907091638330.17835@gentwo.org>
References: <20090709171247.23C6.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907091638330.17835@gentwo.org>
Message-Id: <20090710094934.17CA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 10 Jul 2009 11:11:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 9 Jul 2009, KOSAKI Motohiro wrote:
> 
> > Subject: [PATCH] add isolate pages vmstat
> >
> > If the system have plenty threads or processes, concurrent reclaim can
> > isolate very much pages.
> > Unfortunately, current /proc/meminfo and OOM log can't show it.
> 
> "
> If the system is running a heavy load of processes then concurrent reclaim
> can isolate a large numbe of pages from the LRU. /proc/meminfo and the
> output generated for an OOM do not show how many pages were isolated.
> "
> 
> > This patch provide the way of showing this information.
> 
> "
> This patch shows the information about isolated pages.
> "
> 
> 
> Page migration can also isolate a large number of pages from the LRU. But
> the new counters are not used there.

Correct. Will fix.

Plus, current reclaim logic depend on the system have enough much pages on LRU.
Maybe we don't only need to limit #-of-reclaimer, but also need to limit #-of-migrator.
I think we can use similar logic.





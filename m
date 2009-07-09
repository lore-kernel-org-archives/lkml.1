Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZGIUnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZGIUnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZGIUna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:43:30 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:37435 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754920AbZGIUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:43:29 -0400
Date: Thu, 9 Jul 2009 16:43:02 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
In-Reply-To: <20090709171247.23C6.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907091638330.17835@gentwo.org>
References: <20090709165820.23B7.A69D9226@jp.fujitsu.com> <20090709171247.23C6.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, KOSAKI Motohiro wrote:

> Subject: [PATCH] add isolate pages vmstat
>
> If the system have plenty threads or processes, concurrent reclaim can
> isolate very much pages.
> Unfortunately, current /proc/meminfo and OOM log can't show it.

"
If the system is running a heavy load of processes then concurrent reclaim
can isolate a large numbe of pages from the LRU. /proc/meminfo and the
output generated for an OOM do not show how many pages were isolated.
"

> This patch provide the way of showing this information.

"
This patch shows the information about isolated pages.
"


Page migration can also isolate a large number of pages from the LRU. But
the new counters are not used there.


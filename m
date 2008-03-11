Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYCKEl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYCKEl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYCKElt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:41:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbYCKElt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:41:49 -0400
Date: Mon, 10 Mar 2008 21:41:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Move memory controller allocations to their own slabs
Message-Id: <20080310214100.d7fe7904.akpm@linux-foundation.org>
In-Reply-To: <20080311043149.20251.50059.sendpatchset@localhost.localdomain>
References: <20080311043149.20251.50059.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 10:01:49 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> 
> Move the memory controller data structures page_cgroup and
> mem_cgroup_per_zone to their own slab caches. It saves space on the system,
> allocations are not necessarily pushed to order of 2 and should provide
> performance benefits.

eh?  Those structures are tiny.  Which slab allocator has gone and used an
order-2 allocation and for which structure did it (stupidly) do this?



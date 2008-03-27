Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbYC0JKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbYC0JKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbYC0JJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:09:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47581 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400AbYC0JJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:09:47 -0400
Date: Thu, 27 Mar 2008 18:14:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>
Subject: Re: [RFC][1/3] Add user interface for virtual address space control
 (v2)
Message-Id: <20080327181404.1e95a725.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080326185006.9465.4720.sendpatchset@localhost.localdomain>
References: <20080326184954.9465.19379.sendpatchset@localhost.localdomain>
	<20080326185006.9465.4720.sendpatchset@localhost.localdomain>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 00:20:06 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> 
> Add as_usage_in_bytes and as_limit_in_bytes interfaces. These provide
> control over the total address space that the processes combined together
> in the cgroup can grow upto. This functionality is analogous to
> the RLIMIT_AS function of the getrlimit(2) and setrlimit(2) calls.
> A as_res resource counter is added to the mem_cgroup structure. The
> as_res counter handles all the accounting associated with the virtual
> address space accounting and control of cgroups.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

I wonder that it's better to create "rlimit cgroup" rather than enhancing
memory controller. (But I have no strong opinion.)
How do you think ?

Thanks,
-Kame


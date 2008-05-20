Return-Path: <linux-kernel-owner+w=401wt.eu-S1764491AbYETJfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764491AbYETJfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761566AbYETJfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:35:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55098 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762065AbYETJe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:34:59 -0400
Message-ID: <48329AE0.2010505@cn.fujitsu.com>
Date: Tue, 20 May 2008 17:33:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 3/3] memcg: per node information
References: <20080520180552.601da567.kamezawa.hiroyu@jp.fujitsu.com> <20080520180955.70aa5459.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080520180955.70aa5459.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
>  static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
> Index: mm-2.6.26-rc2-mm1/Documentation/controllers/memory_files.txt
> ===================================================================
> --- mm-2.6.26-rc2-mm1.orig/Documentation/controllers/memory_files.txt
> +++ mm-2.6.26-rc2-mm1/Documentation/controllers/memory_files.txt
> @@ -74,3 +74,13 @@ Files under memory resource controller a
>    (write)
>    Reset to 0.
>  
> +* memory.numa_stat
> +
> +  This file appears only when the kernel is configured as NUMA.
> +
> +  (read)
> +  Show per-node accounting information of acitve/inactive pages.
> +  formated as following.

formatted

> +  nodeid  total active inactive

2 spaces?  ^^

> +
> +  total = active + inactive.
> 
> 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbYKMBlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbYKMBlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 20:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYKMBln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 20:41:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54491 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbYKMBln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 20:41:43 -0500
Message-ID: <491B853D.1020204@cn.fujitsu.com>
Date: Thu, 13 Nov 2008 09:39:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][mm] [PATCH 4/4] Memory cgroup hierarchy feature selector
 (v3)
References: <20081111123314.6566.54133.sendpatchset@balbir-laptop> <20081111123448.6566.55973.sendpatchset@balbir-laptop>
In-Reply-To: <20081111123448.6566.55973.sendpatchset@balbir-laptop>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -137,6 +137,11 @@ struct mem_cgroup {
>  	 * reclaimed from. Protected by cgroup_lock()
>  	 */
>  	struct mem_cgroup *last_scanned_child;
> +	/*
> +	 * Should the accounting and control be hierarchical, per subtree?
> +	 */
> +	unsigned long use_hierarchy;
> +

A minor comment, 'unsigned int' is sufficient, then we save 4 bytes
per mem_cgroup on 64 bits machines.

>  };


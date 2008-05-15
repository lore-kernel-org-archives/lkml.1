Return-Path: <linux-kernel-owner+w=401wt.eu-S1764143AbYEOSW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764143AbYEOSW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbYEOSWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:22:44 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:40766
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763957AbYEOSWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:22:43 -0400
Message-ID: <482C7F70.2020102@qumranet.com>
Date: Thu, 15 May 2008 21:22:40 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 1/4] Add memrlimit controller documentation (v4)
References: <20080514130904.24440.23486.sendpatchset@localhost.localdomain> <20080514130915.24440.56106.sendpatchset@localhost.localdomain>
In-Reply-To: <20080514130915.24440.56106.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (firebolt.argo.co.il [0.0.0.0]); Thu, 15 May 2008 21:22:40 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> +
> +Advantages of providing this feature
> +
> +1. Control over virtual address space allows for a cgroup to fail gracefully
> +   i.e., via a malloc or mmap failure as compared to OOM kill when no
> +   pages can be reclaimed.
>   

Do you mean by this, limiting the number of pagetable pages (that are 
pinned in memory), this preventing oom by a cgroup that instantiates 
many pagetables?


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


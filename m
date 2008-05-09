Return-Path: <linux-kernel-owner+w=401wt.eu-S934802AbYEIF7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934802AbYEIF7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 01:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYEIF6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 01:58:55 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:57707 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYEIF6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 01:58:54 -0400
Message-ID: <4823E819.1000607@linux.vnet.ibm.com>
Date: Fri, 09 May 2008 11:28:49 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "xemul@openvz.org" <xemul@openvz.org>, lizf@cn.fujitsu.com,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [PATCH] memcg: make global var to be read_mostly
References: <20080509145631.408a9a67.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080509145631.408a9a67.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> An easy cut out from memcg: performance improvement patch set.
> Tested on: x86-64/linux-2.6.26-rc1-git6
> 
> Thanks,
> -Kame
> 
> ==
> mem_cgroup_subsys and page_cgroup_cache should be read_mostly and
> MEM_CGROUP_RECLAIM_RETRIES can be just a fixed number.
> 
> Changelog:
>   * makes MEM_CGROUP_RECLAIM_RETRIES to be a macro
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> 

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

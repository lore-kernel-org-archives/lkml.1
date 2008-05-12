Return-Path: <linux-kernel-owner+w=401wt.eu-S1760344AbYELJcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344AbYELJcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 05:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbYELJcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 05:32:10 -0400
Received: from sacred.ru ([62.205.161.221]:55835 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303AbYELJcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 05:32:09 -0400
Message-ID: <48280DB0.7030608@openvz.org>
Date: Mon, 12 May 2008 13:28:16 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, lizf@cn.fujitsu.com,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [PATCH] memcg: make global var to be read_mostly
References: <20080509145631.408a9a67.kamezawa.hiroyu@jp.fujitsu.com> <4823E819.1000607@linux.vnet.ibm.com>
In-Reply-To: <4823E819.1000607@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 12 May 2008 13:30:49 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> KAMEZAWA Hiroyuki wrote:
>> An easy cut out from memcg: performance improvement patch set.
>> Tested on: x86-64/linux-2.6.26-rc1-git6
>>
>> Thanks,
>> -Kame
>>
>> ==
>> mem_cgroup_subsys and page_cgroup_cache should be read_mostly and
>> MEM_CGROUP_RECLAIM_RETRIES can be just a fixed number.
>>
>> Changelog:
>>   * makes MEM_CGROUP_RECLAIM_RETRIES to be a macro
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>>
> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 

Acked-by: Pavel Emelyanov <xemul@openvz.org>

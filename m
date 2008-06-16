Return-Path: <linux-kernel-owner+w=401wt.eu-S1761508AbYFPJOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761508AbYFPJOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 05:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbYFPJO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 05:14:27 -0400
Received: from sacred.ru ([62.205.161.221]:57480 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223AbYFPJO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 05:14:27 -0400
Message-ID: <48562B6B.4080000@openvz.org>
Date: Mon, 16 Jun 2008 12:59:23 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/6] res_counter:  handle limit change
References: <20080613182714.265fe6d2.kamezawa.hiroyu@jp.fujitsu.com> <20080613182924.c73fe9eb.kamezawa.hiroyu@jp.fujitsu.com> <48562AFF.9050804@linux.vnet.ibm.com>
In-Reply-To: <48562AFF.9050804@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 16 Jun 2008 13:01:40 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> KAMEZAWA Hiroyuki wrote:
>> Add a support to shrink_usage_at_limit_change feature to res_counter.
>> memcg will use this to drop pages.
>>
>> Change log: xxx -> v4 (new file.)
>>  - cut out the limit-change part from hierarchy patch set.
>>  - add "retry_count" arguments to shrink_usage(). This allows that we don't
>>    have to set the default retry loop count.
>>  - res_counter_check_under_val() is added to support subsystem.
>>  - res_counter_init() is res_counter_init_ops(cnt, NULL)
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
> 
> Does shrink_usage() really belong to res_counters? Could a task limiter, a
> CPU/IO bandwidth controller use this callback? Resource Counters were designed
> to be generic and work across controllers. Isn't the memory controller a better
> place for such ops.

Well, this was my point, I just couldn't express this in an understandable manner.
We're discussing this right now :)


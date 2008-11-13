Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYKMNdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYKMNdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYKMNdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:33:38 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:40773 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbYKMNdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:33:38 -0500
Message-ID: <491C2CA3.1070903@linux.vnet.ibm.com>
Date: Thu, 13 Nov 2008 19:03:23 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080715)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][mm] [PATCH 3/4] Memory cgroup hierarchical reclaim (v3)
References: <20081111123314.6566.54133.sendpatchset@balbir-laptop> <20081111123417.6566.52629.sendpatchset@balbir-laptop> <20081112140236.46448b47.kamezawa.hiroyu@jp.fujitsu.com> <491A6E71.5010307@linux.vnet.ibm.com> <20081112150126.46ac6042.kamezawa.hiroyu@jp.fujitsu.com> <491A7345.4090500@linux.vnet.ibm.com> <20081112151233.0ec8dc44.kamezawa.hiroyu@jp.fujitsu.com> <491A7637.3050402@linux.vnet.ibm.com> <20081112153314.a7162192.kamezawa.hiroyu@jp.fujitsu.com> <20081112112141.GA25386@balbir.in.ibm.com> <20081113131807.b2f22261.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081113131807.b2f22261.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 12 Nov 2008 16:51:41 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> 
>> Here is the iterative version of this patch. I tested it in my
>> test environment. NOTE: The cgroup_locked check is still present, I'll
>> remove that shortly after your patch is accepted.
>>
>> This patch introduces hierarchical reclaim. When an ancestor goes over its
>> limit, the charging routine points to the parent that is above its limit.
>> The reclaim process then starts from the last scanned child of the ancestor
>> and reclaims until the ancestor goes below its limit.
>>
> 
> complicated as you said but it seems it's from style.
> 
> I expected following kind of one.

Thanks, it looks very similar to what I have, I like the split of the iterator,
start token and next token. I'll refactor the code based on your suggestion if
possible in the next version.

-- 
	Balbir

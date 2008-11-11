Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbYKKFBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbYKKFBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 00:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbYKKFB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 00:01:26 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:47196 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYKKFBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 00:01:25 -0500
Message-ID: <4919118C.9060701@linux.vnet.ibm.com>
Date: Tue, 11 Nov 2008 10:31:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][mm] [PATCH 4/4] Memory cgroup hierarchy feature selector
 (v2)
References: <20081108091009.32236.26177.sendpatchset@localhost.localdomain> <20081108091113.32236.12390.sendpatchset@localhost.localdomain> <20081111121039.91017d3c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081111121039.91017d3c.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Sat, 08 Nov 2008 14:41:13 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Don't enable multiple hierarchy support by default. This patch introduces
>> a features element that can be set to enable the nested depth hierarchy
>> feature. This feature can only be enabled when the cgroup for which the
>> feature this is enabled, has no children.
>>
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>> ---
>>
> IMHO, permission to this is not enough.
> 
> I think following is sane way.
> ==
>    When parent->use_hierarchy==1.
> 	my->use_hierarchy must be "1" and cannot be tunrned to be "0" even if no children.
>    When parent->use_hierarchy==0
> 	my->use_hierarchy can be either of "0" or "1".
> 	this value can be chagned if we don't have children
> ==

Sounds reasonable, will fix in v3.

-- 
	Balbir

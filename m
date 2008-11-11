Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYKKGYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYKKGYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYKKGY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:24:28 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:47292 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbYKKGY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:24:27 -0500
Message-ID: <49192510.3060603@linux.vnet.ibm.com>
Date: Tue, 11 Nov 2008 11:54:16 +0530
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
Subject: Re: [RFC][mm] [PATCH 3/4] Memory cgroup hierarchical reclaim (v2)
References: <20081108091009.32236.26177.sendpatchset@localhost.localdomain> <20081108091100.32236.89666.sendpatchset@localhost.localdomain> <20081111120607.5ffe8a9c.kamezawa.hiroyu@jp.fujitsu.com> <49190E5F.2050109@linux.vnet.ibm.com> <20081111140113.fc24d317.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081111140113.fc24d317.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
>>
> please see mem+swap controller's refcnt-to-memcg for delaying free of memcg.
> it will be a hint.
> 

I'll integrate with those patches later. I see a memcg->swapref, but we don't
need to delay deletion for last_scanned_child, we need to make sure that the
parent does not have any invalid entries.

-- 
	Balbir

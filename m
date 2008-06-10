Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYFJFNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYFJFNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 01:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYFJFNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 01:13:44 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:60091 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbYFJFNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 01:13:43 -0400
Message-ID: <484E0D73.6010609@linux.vnet.ibm.com>
Date: Tue, 10 Jun 2008 10:43:23 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrea Righi <righi.andrea@gmail.com>, menage@google.com,
       kosaki.motohiro@jp.fujitsu.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [RFC PATCH 0/5] memcg: VM overcommit accounting and handling
References: <1213054383-18137-1-git-send-email-righi.andrea@gmail.com> <20080610091439.04061da9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080610091439.04061da9.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 10 Jun 2008 01:32:58 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
>> Provide distinct cgroup VM overcommit accounting and handling using the memory
>> resource controller.
>>
> 
> Could you explain the benefits of this even when we have memrlimit controller ?
> (If unsure, see 2.6.26-rc5-mm1 and search memrlimit controller.)
> 
> And this kind of virtual-address-handling things should be implemented on
> memrlimit controller (means not on memory-resource-controller.).
> It seems this patch doesn't need to handle page_group.
> 
> Considering hierarchy, putting several kinds of features on one controller is
> not good, I think. Balbir, how do you think ?
> 

I would tend to agree. With the memrlimit controller, can't we do this in user
space now? Figure out the overcommit value and based on that setup the memrlimit?


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

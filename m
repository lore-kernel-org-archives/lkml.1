Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYDUKZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYDUKZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbYDUKZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:25:11 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:45630 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbYDUKZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:25:09 -0400
Message-ID: <480C6AA1.5000607@linux.vnet.ibm.com>
Date: Mon, 21 Apr 2008 15:51:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, shiwh@cn.fujitsu.com,
       mel@csn.ul.ie, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26 (memcgroup)
References: <20080420072053.6bcb7884.akpm@linux-foundation.org> <Pine.LNX.4.64.0804210004470.1630@blonde.site> <20080421093059.57a61bc3.kamezawa.hiroyu@jp.fujitsu.com> <20080420232427.1b399104.akpm@linux-foundation.org> <480C347C.6060702@linux.vnet.ibm.com> <20080421064725.GA32214@balbir.in.ibm.com> <1208770925.7115.167.camel@twins>
In-Reply-To: <1208770925.7115.167.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This would enable the memory controller by default, it can be disabled
>> using cgroup_disable=memory at boot time.
> 
> how about working on a runtime switch that only enables the whole
> memcgroup machinery when an actual cgroup gets created - and disable it
> again once the last cgroup goes.
> 

Sounds like an interesting option to explore. I'll explore that a bit more.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

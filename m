Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbYKKExV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbYKKExV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 23:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYKKExN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 23:53:13 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:52322 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYKKExN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 23:53:13 -0500
Message-ID: <49190FA3.3040003@linux.vnet.ibm.com>
Date: Tue, 11 Nov 2008 10:22:51 +0530
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
Subject: Re: [RFC][mm] [PATCH 2/4] Memory cgroup resource counters for hierarchy
 (v2)
References: <20081108091009.32236.26177.sendpatchset@localhost.localdomain> <20081108091047.32236.22994.sendpatchset@localhost.localdomain> <20081111120427.bbb64a44.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081111120427.bbb64a44.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Sat, 08 Nov 2008 14:40:47 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Add support for building hierarchies in resource counters. Cgroups allows us
>> to build a deep hierarchy, but we currently don't link the resource counters
>> belonging to the memory controller control groups, in the same fashion
>> as the corresponding cgroup entries in the cgroup hierarchy. This patch
>> provides the infrastructure for resource counters that have the same hiearchy
>> as their cgroup counter parts.
>>
>> These set of patches are based on the resource counter hiearchy patches posted
>> by Pavel Emelianov.
>>
>> NOTE: Building hiearchies is expensive, deeper hierarchies imply charging
>> the all the way up to the root. It is known that hiearchies are expensive,
>> so the user needs to be careful and aware of the trade-offs before creating
>> very deep ones.
>>
> Do you have numbers ?
> 

I am getting those numbers, I'll post them soon.

-- 
	Balbir

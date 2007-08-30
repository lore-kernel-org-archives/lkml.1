Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbXH3JPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbXH3JPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 05:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759365AbXH3JPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 05:15:23 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:44033 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbXH3JPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 05:15:21 -0400
Message-ID: <46D68A2B.7040106@linux.vnet.ibm.com>
Date: Thu, 30 Aug 2007 14:43:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Dave Hansen <haveblue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm PATCH] Memory controller improve user interface
References: <20070829111030.9987.8104.sendpatchset@balbir-laptop> <1188413148.28903.113.camel@localhost> <46D5ED5C.9030405@linux.vnet.ibm.com> <1188425894.28903.140.camel@localhost> <6599ad830708291520t2bc9ea20m2bdcd9e042b3a423@mail.gmail.com> <1188426352.28903.143.camel@localhost> <46D5F517.1080809@linux.vnet.ibm.com> <20070830143859.e9d3511a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070830143859.e9d3511a.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 30 Aug 2007 04:07:11 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> 1. Several people recommended it
>> 2. Herbert mentioned that they've moved to that interface and it
>>    was working fine for them.
>>
> 
> I have no strong opinion. But how about Mega bytes ? (too big ?)
> There will be no rounding up/down problem.
> 

Here is what I am thinking, allow the user to input bytes/kilobytes/
megabytes or gigabytes. Store the data internally in kilobytes or
PFN. I prefer kilobytes (no rounding issues), but while implementing
limits we round up to the closest PFN.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

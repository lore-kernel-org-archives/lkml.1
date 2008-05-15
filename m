Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbYEOSkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbYEOSkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYEOSj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:39:57 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:48748 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbYEOSj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:39:56 -0400
Message-ID: <482C8353.8080008@linux.vnet.ibm.com>
Date: Fri, 16 May 2008 00:09:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 1/4] Add memrlimit controller documentation (v4)
References: <20080514130904.24440.23486.sendpatchset@localhost.localdomain> <20080514130915.24440.56106.sendpatchset@localhost.localdomain> <482C7F70.2020102@qumranet.com>
In-Reply-To: <482C7F70.2020102@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Balbir Singh wrote:
>> +
>> +Advantages of providing this feature
>> +
>> +1. Control over virtual address space allows for a cgroup to fail
>> gracefully
>> +   i.e., via a malloc or mmap failure as compared to OOM kill when no
>> +   pages can be reclaimed.
>>   
> 
> Do you mean by this, limiting the number of pagetable pages (that are
> pinned in memory), this preventing oom by a cgroup that instantiates
> many pagetables?
> 
> 

This is not for page tables (that is in the long term TODO list). This is more
for user space calls to mmap(), malloc() or anything that causes the total
virtual memory of the process to go up (in our case cgroups). The motivation is
similar to the motivations of RLIMIT_AS.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

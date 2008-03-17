Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYCQBwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYCQBwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYCQBv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:51:56 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:40201 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbYCQBvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:51:55 -0400
Message-ID: <47DDCE5E.9020104@linux.vnet.ibm.com>
Date: Mon, 17 Mar 2008 07:20:22 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][0/3] Virtual address space control for cgroups
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain> <6599ad830803161626q1fcf261bta52933bb5e7a6bdd@mail.gmail.com>
In-Reply-To: <6599ad830803161626q1fcf261bta52933bb5e7a6bdd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Mon, Mar 17, 2008 at 1:29 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> This is an early patchset for virtual address space control for cgroups.
>>  The patches are against 2.6.25-rc5-mm1 and have been tested on top of
>>  User Mode Linux.
> 
> What's the performance hit of doing these accounting checks on every
> mmap/munmap? If it's not totally lost in the noise, couldn't it be
> made a separate control group, so that it could be just enabled (and
> the performance hit taken) for users that actually want it?
> 

I am yet to measure the performance overhead of the accounting checks. I'll try
and get started on that today. I did not consider making it a separate system,
because I suspect that anybody wanting memory control would also want address
space control (for the advantages listed in the documentation). I am not against
the idea of making it a separate subsystem, but first let me get back with the
numbers.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

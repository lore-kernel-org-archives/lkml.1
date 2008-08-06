Return-Path: <linux-kernel-owner+w=401wt.eu-S1764053AbYHFDbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764053AbYHFDbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYHFDaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:30:16 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:46220 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYHFDaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:30:14 -0400
Message-ID: <48991ABF.906@linux.vnet.ibm.com>
Date: Wed, 06 Aug 2008 09:00:07 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, vtaras@openvz.org,
       dm-devel@redhat.com, agk@sourceware.org, ngupta@google.com,
       righi.andrea@gmail.com
Subject: Re: Too many I/O controller patches
References: <20080804.175126.193692178.ryov@valinux.co.jp> <1217870433.20260.101.camel@nimitz> <489748E6.5080106@gmail.com> <000901c8f6a5$fe64ba30$fb2e2e90$@jp.nec.com> <48981D3B.2020701@gmail.com> <1217953218.10907.25.camel@nimitz> <20080806114425.c0e9b24f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080806114425.c0e9b24f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 05 Aug 2008 09:20:18 -0700
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> 
>> On Tue, 2008-08-05 at 11:28 +0200, Andrea Righi wrote:
>>>> Buffered write I/O is also related with cache system.
>>>> We must consider this problem as I/O control.
>>> Agree. At least, maybe we should consider if an IO controller could be
>>> a valid solution also for these problems.
>> Isn't this one of the core points that we keep going back and forth
>> over?  ﻿It seems like people are arguing in circles over this:
>>
>> Do we:
>> 	1. control potential memory usage by throttling I/O
>> or
>> 	2. Throttle I/O when memory is full
>>
>> I might lean toward (1) if we didn't already have a memory controller.
>> But, we have one, and it works.  Also, we *already* do (2) in the
>> kernel, so it would seem to graft well onto existing mechanisms that we
>> have.
>>
>> I/O controllers should not worry about memory.  
> I agree here ;)
> 
>> They're going to have a hard enough time getting the I/O part right. :)
>>
> memcg have more problems now ;( 
> 
> Only a difficult thing to limit dirty-ratio in memcg is how-to-count dirty
> pages. If I/O controller's hook helps, it's good.
> 
> My small concern is "What happens if we throttole I/O bandwidth too small
> under some memcg." In such cgroup, we may see more OOMs because I/O will
> not finish in time.
> A system admin have to find some way to avoid this.
> 
> But please do I/O control first. Dirty-page control is related but different
> layer's problem, I think.

Yes, please solve the I/O control problem first.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL


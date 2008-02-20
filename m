Return-Path: <linux-kernel-owner+w=401wt.eu-S1765401AbYBTPaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765401AbYBTPaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764933AbYBTPZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:25:15 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:40796 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765716AbYBTPZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:25:12 -0500
Message-ID: <47BC4554.10304@linux.vnet.ibm.com>
Date: Wed, 20 Feb 2008 20:50:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com> <18364.16552.455371.242369@stoffel.org>
In-Reply-To: <18364.16552.455371.242369@stoffel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
> I know this is a pedantic comment, but why the heck is it called such
> a generic term as "Memory Controller" which doesn't give any
> indication of what it does.
> 
> Shouldn't it be something like "Memory Quota Controller", or "Memory
> Limits Controller"?
> 

It's called the memory controller since it controls the amount of memory that a
user can allocate (via limits). The generic term for any resource manager
plugged into cgroups is a controller. If you look through some of the references
in the document, we've listed our plans to support other categories of memory as
well. Hence it's called a memory controller

> Also, the Kconfig name "CGROUP_MEM_CONT" is just wrong, it should be
> "CGROUP_MEM_CONTROLLER", just spell it out so it's clear what's up.
> 

This has some history as well. Control groups was called containers earlier.
That way a name like CGROUP_MEM_CONT could stand for cgroup memory container or
cgroup memory controller.

> It took me a bunch of reading of Documentation/controllers/memory.txt
> to even start to understand what the purpose of this was.  The
> document could also use a re-writing to include a clear introduction
> at the top to explain "what" a memory controller is.  
> 
> Something which talks about limits, resource management, quotas, etc
> would be nice.  
> 


The references, specially reference [1] contains a lot of details on limits,
guarantees, etc.  Since they've been documented in the past on lkml, I decided
to keep them out of the documentation and mention them as references. If it's
going to help to add that terminology; I can create another document describing
what resource management means and what the commonly used terms mean.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

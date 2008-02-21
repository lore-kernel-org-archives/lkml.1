Return-Path: <linux-kernel-owner+w=401wt.eu-S1760298AbYBUFvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298AbYBUFvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 00:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYBUFvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 00:51:42 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:36176 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYBUFvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 00:51:41 -0500
Message-ID: <47BD1052.2090204@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 11:16:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
References: <20080220122338.GA4352@basil.nowhere.org> <200802211535.38932.nickpiggin@yahoo.com.au> <47BD06C2.5030602@linux.vnet.ibm.com> <200802211622.51751.nickpiggin@yahoo.com.au>
In-Reply-To: <200802211622.51751.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>> 1. We could create something similar to mem_map, we would need to handle 4
> 
>> different ways of creating mem_map.
> 
>> 2. On x86 with 64 GB ram, if we decided to use vmalloc space, we would need
> 
>> 64 MB of vmalloc'ed memory
> 
> That's going to be a big job. You could probably do it quite easily for
> 
> flatmem (just store an offset into the start of your page array), and
> 
> maybe even sparsemem (add some "extra" information to the extents).
> 
>> I have not explored your latest suggestion of pfn <-> memory controller
> 
>> mapping yet. I'll explore it and see how that goes.
> 
> If you did that using a radix-tree, then it could be a runtime option
> 
> without having to use vmalloc. And you wouldn't have to care about
> 
> memory models. I'd say it will be the fastest way to get a prototype
> 
> running.
> 

OK, I'll explore and prototype the radix tree based approach and see how that goes.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbYACVIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbYACVIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYACVIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:08:39 -0500
Received: from mga07.intel.com ([143.182.124.22]:37730 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752024AbYACVIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:08:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,240,1196668800"; 
   d="scan'208";a="356951298"
Message-ID: <477D4E50.4020004@linux.intel.com>
Date: Thu, 03 Jan 2008 22:06:24 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] move WARN_ON() out of line
References: <477C32DA.5060905@linux.intel.com> <1199325569.4497.116.camel@cinder.waste.org>
In-Reply-To: <1199325569.4497.116.camel@cinder.waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> 
> I hate the do_foo naming scheme (how about __warn_on?), but otherwise:
> 
> Acked-by: Matt Mackall <mpm@selenic.com>

after I moved it around based on Olof's work, I've now ended up with

warn_on_slowpath()

> 
>> +		printk(KERN_WARNING "WARNING: at %s:%d %s()\n",
>> +			__FILE__, __LINE__, __FUNCTION__);
>> +		dump_stack();
> 
> While we're here, I'll mention that dump_stack probably ought to take a
> severity level argument.

125 files changed, 202 insertions(+), 199 deletions(-)
just to get the api change done.
I can hear akpm cringe from here...

> 


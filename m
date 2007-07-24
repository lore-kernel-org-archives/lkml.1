Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbXGXFjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbXGXFjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 01:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbXGXFjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 01:39:07 -0400
Received: from il.qumranet.com ([82.166.9.18]:41358 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbXGXFjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 01:39:06 -0400
Message-ID: <46A5906B.6080301@qumranet.com>
Date: Tue, 24 Jul 2007 08:38:51 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 7/8]KVM: swap out guest pages
References: <1185173505.2645.71.camel@sli10-conroe.sh.intel.com>	 <46A491C4.8010302@qumranet.com> <1185241908.24201.22.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1185241908.24201.22.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 24 Jul 2007 08:38:51 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
>>>  
>>>       
>> You're not removing any shadows of the page, in case that page is a
>> guest page table.  But I don't see anything wrong with it -- the page
>> won't change while it's in swap.
>>     
> You are right. Should we?
>   

I don't think so.  It's just strange to have shadows for a guest page
that is swapped out, so I pointed that out.  But as the page cannot
change in swap, everything is safe.  I guess that kernel page tables
could be swapped out after a short while in a guest that doesn't swap
its own kernel pages.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


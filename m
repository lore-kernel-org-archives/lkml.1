Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZJEXZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZJEXZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 19:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZJEXZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 19:25:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263AbZJEXZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 19:25:08 -0400
Date: Mon, 5 Oct 2009 16:23:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Len Brown <lenb@kernel.org>, rjw@sisk.pl, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       a.p.zijlstra@chello.nl, shaohua.li@intel.com, svaidy@linux.vnet.ibm.com
Subject: Re: [git pull request] ACPI Processor Aggregator Driver for
 2.6.32-rc1
In-Reply-To: <20091005154021.129a8f9f.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.01.0910051614510.3432@localhost.localdomain>
References: <alpine.LFD.2.00.0910030145140.25240@localhost.localdomain> <20091005033256.GA26592@balbir.in.ibm.com> <200910052159.24920.rjw@sisk.pl> <20091005140415.57f1db5e.akpm@linux-foundation.org> <alpine.LFD.2.00.0910051818130.32307@localhost.localdomain>
 <20091005154021.129a8f9f.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Oct 2009, Andrew Morton wrote:
> 
> But it's all too late now, isn't it.  This is the first time that
> non-linux-acpi readers knew of the existence of this driver.

Why do people even care? This driver is not going to be used in any 
situation where any regular person will _ever_ care. And if you don't 
like it, you don't have to enable it at all.

That driver is ACPI-specific, is not very complex, is marked EXPERIMENTAL, 
and everybody including Len has said that _if_ the scheduler people can 
ever solve it at that level, it would be good. But as it is, it has 
NOTHING to do with the scheduler, and why _should_ any non-ACPI people 
know about the existence of that driver?

In fact, the only reason the scheduler people even know about it is that 
Len at first tried to do something more invasive, and was shot down. Now 
it's just a driver, and the scheduler people can _try_ to do it some other 
way if they really care, but that's _their_ problem. Not the driver.

In the meantime, I personally suspect we probably never want to even try 
to solve it in the scheduler, because why the hell should we care and add 
complex logic for something like that? At least not until we end up having 
the same issue on some other architecture too, and it turns from a hacky 
ACPI thing into something more.

As it is, the driver is entirely self-contained and doesn't affect any 
other subsystem. 

				Linus

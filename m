Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZBPTql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZBPTql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZBPTqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:46:32 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39590 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZBPTqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:46:31 -0500
Message-ID: <4999C199.4090202@cs.helsinki.fi>
Date: Mon, 16 Feb 2009 21:42:17 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator (try 2)
References: <20090123154653.GA14517@wotan.suse.de> <200902041748.41801.nickpiggin@yahoo.com.au> <20090204152709.GA4799@csn.ul.ie> <200902051459.30064.nickpiggin@yahoo.com.au> <20090216184200.GA31264@csn.ul.ie> <84144f020902161125r59de8a53nfe01566d20ff1658@mail.gmail.com> <20090216194401.GC31264@csn.ul.ie>
In-Reply-To: <20090216194401.GC31264@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
>> There's a follow-up patch from Yanmin which
>> will make a difference for large allocations when page-allocator
>> pass-through is reverted:
>>
>> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=79b350ab63458ef1d11747b4f119baea96771a6e
> 
> Is this expected to make a difference to workloads that are not that
> allocator intensive? I doubt it'll make much different to speccpu but
> conceivably it makes a difference to sysbench.

I doubt that too but I fail to see why it's regressing with the revert 
in the first place for speccpu. Maybe it's cache effects, dunno.

			Pekka

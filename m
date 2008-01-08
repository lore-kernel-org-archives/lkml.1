Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbYAHTHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbYAHTHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYAHTHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:07:42 -0500
Received: from mga06.intel.com ([134.134.136.21]:3575 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751505AbYAHTHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:07:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,258,1196668800"; 
   d="scan'208";a="251155645"
Message-ID: <4783C95C.7050303@linux.intel.com>
Date: Tue, 08 Jan 2008 11:05:00 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Kevin Winchester <kjwinchester@gmail.com>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: Top 10 kernel oopses for the week ending January 5th, 2008
References: <477FF149.4070609@linux.intel.com> <20080105213935.GN27894@ZenIV.linux.org.uk> <20080107174431.GC27741@fieldses.org> <4782CF9C.6000508@gmail.com> <alpine.LFD.1.00.0801071851120.3148@woody.linux-foundation.org> <20080108081401.d9576ac5.randy.dunlap@oracle.com> <4783B602.1050307@linux.intel.com> <alpine.LFD.1.00.0801080957280.3148@woody.linux-foundation.org> <4783BE06.1070507@linux.intel.com> <alpine.LFD.1.00.0801081025470.3148@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801081025470.3148@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 8 Jan 2008, Arjan van de Ven wrote:
>> the database has the information so it's just a matter of slightly different
>> php code ;)
>> Before I do that... do you want the BUG's separate, part of the warnings or
>> part of the oopses?
>> (I rather make this change once ;)
> 
> I'd like them all separate, they tend to be very different and contain 
> different information.
> 
> Put the warnings last, as the least important. Oopses at the top, since 
> they tend to be the ones that are less expected.

ok done; I had to fizzle a bit because some things aren't *exactly* a BUG() statement
but I track them anyway (things like the "sleeping in invalid context" check), so I
had to somewhat arbitrarily assign categories for those. I might fine tune these over time
some; if you or someone else sees problems with categorization please let me know


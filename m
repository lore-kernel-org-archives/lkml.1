Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbXJCSa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbXJCSa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbXJCSaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:30:15 -0400
Received: from mga06.intel.com ([134.134.136.21]:37888 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751593AbXJCSaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:30:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,226,1188802800"; 
   d="scan'208";a="238778007"
Message-ID: <4703DF80.5010405@linux.intel.com>
Date: Wed, 03 Oct 2007 11:29:20 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anders Bostr?m <anders@bostrom.dyndns.org>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: high load average when idle
References: <20071002.233731.119908363.anders@bostrom.dyndns.org> <20071002150748.906970bc.akpm@linux-foundation.org> <4702C756.8090108@redhat.com> <20071002162613.54c3ef43@laptopd505.fenrus.org> <4703D212.6040304@redhat.com> <alpine.LFD.0.999.0710031058320.3579@woody.linux-foundation.org> <4703DD8A.80602@linux.intel.com> <alpine.LFD.0.999.0710031125100.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710031125100.3579@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 3 Oct 2007, Arjan van de Ven wrote:
>> not sure this is going to help; I mean, the load gets only updated in actual
>> timer interrupts... and on a tickless system there's very few of those
>> around..... and usually at places round_jiffies() already put a timer on.
> 
> Yeah, you're right. Although in practice, at least on a system running 
> X, I'd expect that there still is lots of other timers going on, hiding 
> the issue.

eh not really; on a normal distro desktop you maybe have 10 
wakeups/sec or so; on a tuned one you have 2 or less.

> 
> Hmm. Maybe Anders' problem stems partly from the fact that he really is 
> using the tweaks to make that tickless theory more true than it tends to 
> be on most systems?

we fixed a TON of stuff over the last months.. standard desktops (F8 / 
next Ubuntu) will be around 10 wakeups/sec, in a lab environment you 
can get below 2 ;)

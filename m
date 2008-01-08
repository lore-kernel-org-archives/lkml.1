Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbYAHSVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbYAHSVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbYAHSVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:21:20 -0500
Received: from mga10.intel.com ([192.55.52.92]:31523 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754044AbYAHSVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:21:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,258,1196668800"; 
   d="scan'208";a="280285664"
Message-ID: <4783BE06.1070507@linux.intel.com>
Date: Tue, 08 Jan 2008 10:16:38 -0800
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
References: <477FF149.4070609@linux.intel.com> <20080105213935.GN27894@ZenIV.linux.org.uk> <20080107174431.GC27741@fieldses.org> <4782CF9C.6000508@gmail.com> <alpine.LFD.1.00.0801071851120.3148@woody.linux-foundation.org> <20080108081401.d9576ac5.randy.dunlap@oracle.com> <4783B602.1050307@linux.intel.com> <alpine.LFD.1.00.0801080957280.3148@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801080957280.3148@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Cool.
> 
> One thing I wonder about - could you separate out the bug-ons and warnings 
> from the oopses? They really are different issues, and an oops with 
> register information etc is very different from a BUG() with line numbers, 
> which in turn is very different from a WARN_ON().


> and in fact three of those five entries are really WARN_ON's. It would be 
> nicer if it would look more along the lines of
> 
> 	Backtraces reported for kernel 2.6.24-rc7
> 
> 
> 	4 oopses reported
> 
> 	hfsplus_releasepage     3
> 	__hfs_brec_find         1
> 
> 
> 	3 warnings repored
> 
> 	enqueue_task            1
> 	lock_acquire            1
> 	__ieee80211_rx          1
> 
> because those things really don't have the same kind of impact at all, and 
> tend to be very different to debug (a "BUG_ON()" is perhaps somewhat 
> closer to an oops, but a WARN_ON() is definitely in a class of its own).

the database has the information so it's just a matter of slightly different php code ;)
Before I do that... do you want the BUG's separate, part of the warnings or part of the oopses?
(I rather make this change once ;)

> 
> On that "Code:" side, it seems there is still some problem with oops 
> parsing. See for example:
> 
> 	http://www.kerneloops.org/raw.php?rawid=1521&msgid=http://mid.gmane.org/20071017154655.GA13394@elte.hu
> 
> and notice how the Code: never made it into the raw message (and thus 
> there is also no instruction disassembly).

ok I'll fix this; I can fix this for all new entries at least, fixing retroactive is going to be
near impossible I suspect.

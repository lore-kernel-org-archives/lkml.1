Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbXJAQ4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbXJAQ4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbXJAQ4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:56:03 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:36904 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbXJAQ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:56:01 -0400
Message-ID: <47012696.2010606@nortel.com>
Date: Mon, 01 Oct 2007 10:55:50 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jarek Poplawski <jarkao2@o2.pl>, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
References: <20070926133138.GA23187@elte.hu> <20070927133123.GA6901@elte.hu> <20070927144228.GC2431@ff.dom.local> <200709281610.00682.nickpiggin@yahoo.com.au> <20071001084356.GA1866@ff.dom.local> <20071001162507.GA22791@elte.hu>
In-Reply-To: <20071001162507.GA22791@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2007 16:55:54.0962 (UTC) FILETIME=[EE72D320:01C8044B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> But, because you assert it that it's risky to "criticise sched_yield() 
> too much", you sure must know at least one real example where it's right 
> to use it (and cite the line and code where it's used, with 
> specificity)?

It's fine to criticise sched_yield().  I agree that new apps should 
generally be written to use proper completion mechanisms or to wait for 
specific events.

However, there are closed-source and/or frozen-source apps where it's 
not practical to rewrite or rebuild the app.  Does it make sense to 
break the behaviour of all of these?

Chris

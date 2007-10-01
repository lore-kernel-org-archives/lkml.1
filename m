Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbXJARqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbXJARqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbXJARps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:45:48 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:49327 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbXJARpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:45:47 -0400
Message-ID: <4701323F.3000500@nortel.com>
Date: Mon, 01 Oct 2007 11:45:35 -0600
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
References: <20070926133138.GA23187@elte.hu> <20070927133123.GA6901@elte.hu> <20070927144228.GC2431@ff.dom.local> <200709281610.00682.nickpiggin@yahoo.com.au> <20071001084356.GA1866@ff.dom.local> <20071001162507.GA22791@elte.hu> <47012696.2010606@nortel.com> <20071001170903.GA2492@elte.hu>
In-Reply-To: <20071001170903.GA2492@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2007 17:45:39.0540 (UTC) FILETIME=[E1654940:01C80452]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Chris Friesen <cfriesen@nortel.com> wrote:

>>However, there are closed-source and/or frozen-source apps where it's 
>>not practical to rewrite or rebuild the app.  Does it make sense to 
>>break the behaviour of all of these?
> 
> 
> See the background and answers to that in:
> 
>    http://lkml.org/lkml/2007/9/19/357
>    http://lkml.org/lkml/2007/9/19/328
> 
> there's plenty of recourse possible to all possible kinds of apps. Tune 
> the sysctl flag in one direction or another, depending on which behavior 
> the app is expecting.

Yeah, I read those threads.

It seems like the fundamental source of the disconnect is that the tasks 
used to be sorted by priority (thus making it easy to bump a yielding 
task to the end of that priority level) while now they're organized by 
time (making it harder to do anything priority-based).  Do I have that 
right?

Chris

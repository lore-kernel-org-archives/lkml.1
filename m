Return-Path: <linux-kernel-owner+w=401wt.eu-S1760408AbXEVUtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbXEVUtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbXEVUtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:49:24 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:50945 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592AbXEVUtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:49:23 -0400
Message-ID: <46535747.4000203@nortel.com>
Date: Tue, 22 May 2007 14:49:11 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au> <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au> <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au> <b647ffbd0705190627x4ff15f3cw19bc292e47257287@mail.gmail.com> <20070521082926.GH19966@holomorphy.com> <20070521085703.GA18755@elte.hu> <46531EF6.3020204@nortel.com> <20070522201518.GC6113@elte.hu>
In-Reply-To: <20070522201518.GC6113@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2007 20:49:15.0079 (UTC) FILETIME=[A8A42570:01C79CB2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Chris Friesen <cfriesen@nortel.com> wrote:

>>Is there a way in CFS to tune the amount of time over which the load 
>>balancer is fair?  (Of course there would be some overhead involved.)

> it should be fair pretty fast (see the 10 seconds run of massive_intr) - 
> so it's not 1 minute (if you were worried about that).

Good to know..that's exactly what I was worried about.  I work with guys 
that really want predictability above all else, then fairness, and only 
then performance--if we can't guarantee a given level of performance for 
5-9s then its useless to us.

Chris

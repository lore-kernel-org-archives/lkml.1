Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbXI1Vls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbXI1Vls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXI1Vlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:41:42 -0400
Received: from mail.tmr.com ([64.65.253.246]:33641 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbXI1Vll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:41:41 -0400
Message-ID: <46FD7640.7000008@tmr.com>
Date: Fri, 28 Sep 2007 17:46:40 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git] CFS-devel, latest code
References: <20070924214537.GA18980@elte.hu> <1190700652.6482.7.camel@Homer.simpson.net> <1190705759.11910.10.camel@Homer.simpson.net> <1190709207.11226.6.camel@Homer.simpson.net> <20070925091331.GA22905@elte.hu> <1190711858.13861.10.camel@Homer.simpson.net> <20070925094712.GA29138@elte.hu>
In-Reply-To: <20070925094712.GA29138@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> Maybe there's more to come: if we can get CONFIG_FAIR_USER_SCHED to work 
> properly then your Xorg will have a load-independent 50% of CPU time all 
> to itself.

It seems that perhaps that 50% makes more sense on a single/dual CPU 
system than on a more robust one, such as a four way dual core Xeon with 
HT or some such. With hotplug CPUs, and setups on various machines, 
perhaps some resource limit independent of the available resource would 
be useful.

Just throwing out the idea, in case it lands on fertile ground.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

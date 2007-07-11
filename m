Return-Path: <linux-kernel-owner+w=401wt.eu-S1765576AbXGKRWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765576AbXGKRWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763910AbXGKRWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:22:23 -0400
Received: from main.gmane.org ([80.91.229.2]:35204 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761255AbXGKRWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:22:21 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [patch] CFS scheduler, -v19
Date: Wed, 11 Jul 2007 13:26:25 -0400
Message-ID: <469512C1.6090406@tmr.com>
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
X-Gmane-NNTP-Posting-Host: pool-70-109-119-137.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <1184054902.12336.19.camel@Homer.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> Greetings,
> 
> On Fri, 2007-07-06 at 19:33 +0200, Ingo Molnar wrote:
>> i'm pleased to announce release -v19 of the CFS scheduler patchset.
> 
> I've taken mainline git tree (freshly integrated CFS!) out for a
> multimedia spin.  I tested watching movies and listenign to music in the
> presence of various sleep/burn loads, pure burn loads, and mixed loads.
> All was peachy here.. I saw no frame drops or sound skips or other
> artifacts under any load where the processor could possibly meet demand.
> 
I would agree with preliminary testing, save that if you get a lot of 
processes updating the screen at once, there seems to be a notable case 
of processes getting no CPU for 100-300ms, followed by a lot of CPU.

I see this clearly with the "glitch1" test with four scrolling xterms 
and glxgears, but also watching videos with little busy processes on the 
screen. The only version where I never see this in test or with real use 
is cfs-v13.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot


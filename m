Return-Path: <linux-kernel-owner+w=401wt.eu-S1032157AbXEHVGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032157AbXEHVGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967854AbXEHVFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:05:54 -0400
Received: from mail.tmr.com ([64.65.253.246]:36273 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967474AbXEHVFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:05:52 -0400
Message-ID: <4640E64D.3070304@tmr.com>
Date: Tue, 08 May 2007 17:06:21 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Preempt of BKL and with tickless systems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think I have a reasonable grip on the voluntary and full preempt 
models, can anyone give me any wisdom on the preempt of the BKL? I know 
what it does, the question is where it might make a difference under 
normal loads. Define normal as servers and desktops.

I've been running some sched tests, and it seems to make little 
difference how that's set. Before I run a bunch of extra tests, I 
thought I'd ask.


New topic: I have found preempt, both voluntary and forced, seems to 
help more with response as the HZ gets smaller. How does that play with 
tickless operation, or are you-all waiting for me to run my numbers with 
all values of HZ and not, and tell the world what I found? ;-)

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

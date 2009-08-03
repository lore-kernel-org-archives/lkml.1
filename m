Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZHCTwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZHCTwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbZHCTwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:52:32 -0400
Received: from mail.tmr.com ([64.65.253.246]:40313 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbZHCTwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:52:31 -0400
Message-ID: <4A773FFD.4050709@tmr.com>
Date: Mon, 03 Aug 2009 15:52:29 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Sherif Fadel <fahmy@vt.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: scheduling co-processors
References: <1249312084.5762.17.camel@sherif-laptop>
In-Reply-To: <1249312084.5762.17.camel@sherif-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sherif Fadel wrote:
> Hi,
> 
> I have a dual-core system on which I would like to treat one processor
> as a scheduling co-processor. I have already implemented some custom
> scheduling policies and tested them with SMP disabled, I would not like
> to see if it is possible to have the scheduling algorithm running on one
> core and the scheduled tasks running on another.
> 
> I do not know if I can somehow use cpus_allowed to restrict the kernel
> to one core and the running tasks to another. Is this possible? If so,
> could you please inform me how one would go about this?
> 
You can look at cpu affinity and see if it does some of what you want.

> In case you are wondering why I would need this, I am writing a bunch of
> high-overhead distributed scheduling algorithms and I want to mitigate
> their overhead in this way.
> 
> Thanks.
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

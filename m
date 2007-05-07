Return-Path: <linux-kernel-owner+w=401wt.eu-S934211AbXEGO3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211AbXEGO3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934189AbXEGO3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:29:02 -0400
Received: from main.gmane.org ([80.91.229.2]:36494 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934192AbXEGO3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:29:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: swap-prefetch: 2.6.22 -mm merge plans
Date: Mon, 07 May 2007 10:28:56 -0400
Message-ID: <463F37A8.1020009@tmr.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <463AE1EB.1020909@yahoo.com.au> <20070504085201.GA24666@elte.hu> <200705042210.15953.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <200705042210.15953.kernel@kolivas.org>
Cc: linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Friday 04 May 2007 18:52, Ingo Molnar wrote:
>> agreed. Con, IIRC you wrote a testcase for this, right? Could you please
>> send us the results of that testing?
> 
> Yes, sorry it's a crappy test app but works on 32bit. Timed with prefetch 
> disabled and then enabled swap prefetch saves ~5 seconds on average hardware 
> on this one test case. I had many users try this and the results were between 
> 2 and 10 seconds, but always showed a saving on this testcase. This effect 
> easily occurs on printing a big picture, editing a large file, compressing an 
> iso image or whatever in real world workloads. Smaller, but much more 
> frequent effects of this over the course of a day obviously also occur and do 
> add up.
> 
I'll try this when I get the scheduler stuff done, and also dig out the 
"resp1" stuff for "back when." I see the most recent datasets were 
comparing 2.5.43-mm2 responsiveness with 2.4.19-ck7, you know I always 
test your stuff ;-)

Guess it might need a bit of polish for current hardware, I was testing 
on *small* machines, deliberately.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot


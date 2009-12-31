Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbZLaCta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbZLaCta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 21:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZLaCt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 21:49:29 -0500
Received: from mail.tmr.com ([64.65.253.246]:58918 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbZLaCt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 21:49:29 -0500
Message-ID: <4B3C1137.8060308@tmr.com>
Date: Wed, 30 Dec 2009 21:49:27 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>
In-Reply-To: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yuhong Bao wrote:
> Given that Linus was once talking about the performance penalties of PAE and HIGHMEM64G, perhaps you'd find these benchmarks done by Phoronix of interest:
> http://www.phoronix.com/scan.php?page=article&item=ubuntu_32_pae
> 
I find these tests mirror my own experience with PAE, the benefit of having the 
nx hardware enabled justifies the few percent drop in performance I was able to 
find.

I find the huge gain in web service hard to believe without a hint why a 64 bit 
CPU would be 15x faster. The disk, memory, and network wouldn't be faster, and 
the CPU intensive tests weren't significantly faster, so unless the systems were 
tuned differently where's the gain? Same feeling about the TP test, an order of 
magnitude faster on a test running the same application on the same hardware is 
hard to buy without an explanation.

The only obvious source I can think of is running the test load at 100Mbit on
one test and Gbit on another, because I saw an early network driver do just that
in negotiations with a switch.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

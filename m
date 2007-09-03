Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbXICOr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbXICOr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 10:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbXICOrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 10:47:20 -0400
Received: from mail.tmr.com ([64.65.253.246]:39715 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbXICOrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 10:47:20 -0400
Message-ID: <46DC1E9B.3030108@tmr.com>
Date: Mon, 03 Sep 2007 10:47:55 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: bjdouma@xs4all.nl
CC: linux-kernel@vger.kernel.org
Subject: Re: bogomips discrepancy on Intel Core2 Quad CPU
References: <46DBC092.8030209@xs4all.nl>
In-Reply-To: <46DBC092.8030209@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bauke Jan Douma wrote:
> $> uname -a
> Linux skyscraper 2.6.22.5 #7 SMP PREEMPT Sun Sep 2 12:12:25 CEST 2007 
> i686 GNU/Linux
> 
> $> cat /proc/cpuinfo | grep bogomips
> bogomips    : 4813.46
> bogomips    : 4810.91
> bogomips    : 4810.91
> bogomips    : 10583.94
> 
> The latter seems way off base.
> Prod me for more info.
> 
I see this occasionally on a dual, speedstep (or similar) finds a way to 
throttle down the cores under light load. I suspect that if you load the 
system:

   for n in 1 2 3 4; do
     nice -19 bash -c 'while true; do a=$RANDOM; done' &
   done

Then you should see your bogomips rise on all cores.


> bjd

	[... copy of output snipped, see the O.P. ...]

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

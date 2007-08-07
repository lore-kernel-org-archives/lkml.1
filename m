Return-Path: <linux-kernel-owner+w=401wt.eu-S1760806AbXHGSwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806AbXHGSwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 14:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbXHGSwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 14:52:04 -0400
Received: from main.gmane.org ([80.91.229.2]:49677 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbXHGSwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 14:52:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Date: Tue, 07 Aug 2007 14:55:18 -0400
Message-ID: <46B8C016.6090806@tmr.com>
References: <20070803123712.987126000@chello.nl>	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>	<20070804063217.GA25069@elte.hu>	<20070804070737.GA940@elte.hu>	<20070804103347.GA1956@elte.hu>	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>	<20070804163733.GA31001@elte.hu>	<alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>	<46B4C0A8.1000902@garzik.org>	<20070804191205.GA24723@lazybastard.org>	<20070804192130.GA25346@elte.hu> <20070804211156.5f600d80@the-village.bc.nu> <46B4E161.9080100@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: pool-70-109-119-137.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <46B4E161.9080100@garzik.org>
Cc: linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Alan Cox wrote:
>> In some setups it will and in others it won't. Nor is it the only
>> application that has this requirement. Ext3 currently is a standards
>> compliant file system. Turn off atime and its very non standards
>> compliant, turn to relatime and its not standards compliant but nobody
>> will break (which is good)
> 
> Linux has always been a "POSIX unless its stupid" type of system.  For 
> the upstream kernel, we should do the right thing -- noatime by default 
> -- but allow distros and people that care about rigid compliance to 
> easily change the default.
> 
However, relatime has the POSIX behavior without the overhead. Therefore 
that (and maybe reldiratime?) are a far better choice. I don't see a big 
problem with some version of utils not supporting it, since it can be in 
the kernel and will be in the utils soon enough. We have lived without 
it this long, sounds as if we could live a bit longer.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot


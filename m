Return-Path: <linux-kernel-owner+w=401wt.eu-S1765866AbXE2Ucp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765866AbXE2Ucp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760226AbXE2Uci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:32:38 -0400
Received: from mail.tmr.com ([64.65.253.246]:33587 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759597AbXE2Uci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:32:38 -0400
Message-ID: <465C8DEC.3050903@tmr.com>
Date: Tue, 29 May 2007 16:32:44 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Tommy Vercetti <vercetti@zlew.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
References: <200705261505.38109@gj-laptop>
In-Reply-To: <200705261505.38109@gj-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tommy Vercetti wrote:
> Hi folks, 
> 
> I was trying to get answer to my question around, but no one knows.
> I do have DMA turned on, etc, yet - on extensive harddrive operations wait 
> time is 90+% , which means that machine is waiting, rather than doing 
> something meanwhile. (I guess). 
> Can someone describe to me , in more detail why is that happening, and what 
> steps should I consider to avoid it ? I couldn't find any answers that would 
> have help me on net.
> 
> thanks.

 From later posts I suspect that your disk performance just sucks, but 
do  use one of the monitoring tools and follow the actual disk work, in 
term of seeks and transfer rate.

I've been looking at high iowait while disk and network are (nearly) 
idle, but it sounds as if you just have a bad match of CPU and disk speed.

Can you borrow a USB drive to use for some testing? USB 2 needed to be 
faster than your old 4200 rpm drive.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763101AbXF0U1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763101AbXF0U1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbXF0U1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:27:16 -0400
Received: from main.gmane.org ([80.91.229.2]:44347 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbXF0U1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:27:15 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Question about fair schedulers
Date: Wed, 27 Jun 2007 16:28:21 -0400
Message-ID: <4682C865.7080307@tmr.com>
References: <200706230007.15622.info@gnebu.es> <200706231300.18840.info@gnebu.es> <7b9198260706230405y5c4a173dx82a18fcc14a10272@mail.gmail.com> <200706231326.34918.info@gnebu.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Tom Spink <tspink@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <200706231326.34918.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alberto Gonzalez wrote:
> On Saturday 23 June 2007, Tom Spink wrote:
>> Alberto,
>>
>> If you're feeling adventurous, grab the latest kernel and patch it
>> with Ingo's scheduler: CFS.
>>
>> You may be pleasantly surprised.
> 
> Thanks, I might if I have to courage to patch and compile my own kernel :)
> 
> However, I'd also need to change all my applications to set them with the 
> right priority to see the good results, so I think I might just wait until it 
> lands in mainline.

In general not the case. I generally don't diddle my priorities, there's 
rarely a need.
> 
> Just to check if I understood everything correctly:
> 
> The mainline scheduler tries to be smart and guess the priority of each task, 
> and while it mostly hits the nail right in the head, sometimes it hits you 
> right in the thumb.
> 
> Fair schedulers, on the contrary, forget about trying to be smart and just 
> care about being fair, leaving the priority settings to where they belong: 
> applications.
> 
> Is this more or less correct?

Incomplete. The CFS scheduler seems to do better with latency, so you 
may get less CPU to a process but it doesn't wind up waiting a long time 
to get a fair share. So it "feels better" without micro tuning.

Face it, if you have more jobs than CPU no scheduler is going to make 
you really happy.
> 
> Alberto.
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot


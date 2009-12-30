Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbZL3VoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbZL3VoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZL3VoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:44:10 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44114 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbZL3VoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:44:09 -0500
Date: Wed, 30 Dec 2009 22:44:08 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Lutomirski <luto@mit.edu>
Subject: Re: [Bug #14887] suspend doesn't work on X200s
Message-ID: <20091230214408.GS4489@kernel.dk>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.Zg.inhOLB@chimera> <20091230111745.GC4489@kernel.dk> <alpine.DEB.1.10.0912301232570.27231@uplift.swm.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0912301232570.27231@uplift.swm.pp.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30 2009, Mikael Abrahamsson wrote:
> On Wed, 30 Dec 2009, Jens Axboe wrote:
>
>> Works fine for me on an x200s. The only issue I seem to have is that  
>> sometimes it suspends immediately upon resume again, presumably the lid 
>> close event is re-triggered (or something to that extent). Apart from  
>> that, 2.6.32 and current -git works fine for me.
>
> There is an issue in 2.6.31 where it will panic (at least that's what I  
> think it does, please see more details in  
> <https://bugs.launchpad.net/bugs/473876>) when you have it plugged in,  
> suspend, un-plug the power cable, and then resume it.

I do that all the time, not a problem here. Tried it just now and it
worked, but did the "I'll suspend immediately again". Pressing fn makes
it wake up, though.

>
> According to 
> <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/467877> it has 
> something to do with "event_when_closed_battery", I haven't tested it yet 
> though, neither with 2.6.31 nor 2.6.32. Could be beneficial for more 
> people to test though.
>
> -- 
> Mikael Abrahamsson    email: swmike@swm.pp.se

-- 
Jens Axboe


Return-Path: <linux-kernel-owner+w=401wt.eu-S1422908AbXCBHGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422908AbXCBHGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 02:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422909AbXCBHGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 02:06:50 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:61982 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422908AbXCBHGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 02:06:49 -0500
Date: Fri, 02 Mar 2007 02:06:09 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: belkin bulldog ups monitor vs 2.6.21-rc2
In-reply-to: <200703020042.17902.gene.heskett@gmail.com>
To: linux-kernel@vger.kernel.org
Message-id: <200703020206.09721.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703020042.17902.gene.heskett@gmail.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2007, Gene Heskett wrote:
>Greetings;
>
>I just rebooted to 2.6.21-rc2 and noted that getting x up and running
> was about 15 seconds longer than usual.  When it got a bash shell going
> I went to it and ran htop which showed that the bulldog monitor was
> taking 90% of the cpu.  Killed it, then restarted it, but when I ran
> the gui which ran fine and then stopped the gui, the daemon once again
> went hog wild and had to be killed,  and I'm losing my kmail composer
> focus for 30 seconds at a time now that amanda is making her nightly
> run.
>
>There is nothing in the log about it other than from xinetd as it ran
> the amanda server stuff.
>
>Not quite ready for prime time methinks.  Using the ck scheduler, this
> is terrible performance, virtually no multitasking.  Back to 2.6.20-ck1
> in the morning if it lives the rest of the night.

Addendum, amanda finished early, it seems tar thought every level was a 
level 0, so it ran out of storage after only 3 dle's were processed and 
backed up.  There are about 25 dle's.  It tried to put 11GB on an 8GB 
vtape, which because it was a vtape, it could do.

So it appears something in the ext3 filesystem is sadly miss-informing tar 
when it does the estimate scan vs doing the real file reading.  Or the 
scan is updating the ctime?

I'm back on 2.6.20-ck1 & everything is copacetic again.  I'll find out if 
the filesystem is damaged tomorrow night cause if the ctimes are all 
screwed up, amanda will effectively be starting from scratch.  That is 
not exactly a Good Thing(TM).

I did find the ls -lt command, and the filesystem looks ok timewise when 
rebooted now.  I have no more ready clues without your able questions to 
guide me on this.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

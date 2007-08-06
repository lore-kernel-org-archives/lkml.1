Return-Path: <linux-kernel-owner+w=401wt.eu-S932691AbXHFSaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbXHFSaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbXHFSad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:30:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4345 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755927AbXHFSac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:30:32 -0400
Date: Mon, 6 Aug 2007 18:30:19 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Gautam Iyer <gautam@math.stanford.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Increased CPU usage after upgrading to 2.6.21
Message-ID: <20070806183019.GA5761@ucw.cz>
References: <20070718164347.GE9506@math.stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718164347.GE9506@math.stanford.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I recently upgraded from 2.6.19, and found the following issues:
> 
>     1. 2.6.20 crashed and ran terribly on my system.
> 
>     2. 2.6.21 runs on my system, but has a few issues: First, I noticed
>        that in 2.6.19 when my system was idle, Gkrellm would show my CPU
>        usage as 0%. In 2.6.21, when my system is idle, Gkrellm shows my
>        cpu usage as anything between 1 and 3%.
> 
>        Second, I noticed that X sometimes crashes on resume (i.e. when I
>        wake my computer up after suspending to ram). Again, this happens
>        only *sometimes*, and is not consistently reproducible. I had no
>        issues with 2.6.19 (which I used for a long time).
> 
>     3. For 2.6.22.1: The CPU usage issue is the same as above. I only
>        tested the kernel for a brief period of time (minutes), during
>        which I experienced no crash.
> 
> If you have any idea why my CPU usage is reported higher, please let me
> know. I've attached the config files of both my kernels.
> 
> About the random crash: I'm not sure how to give you more info on it,
> since I can't consistently reproduce it. Would you have any suggestions
> on what I should do to trace the problem down?

Well, try suspend 50 times in a row to make it reproducible? Then try
unloading modules...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

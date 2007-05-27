Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbXE0VOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbXE0VOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbXE0VOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:14:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1681 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759570AbXE0VOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:14:46 -0400
Date: Sun, 27 May 2007 21:14:35 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
Message-ID: <20070527211434.GG3989@ucw.cz>
References: <4658B7DD.3060309@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4658B7DD.3060309@tmr.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-05-26 18:42:37, Bill Davidsen wrote:
> I was testing susp2disk in 2.6.21.1 under FC6, to 
> support reliable computing environment (RCE) needs. The 
> idea is that if power fails, after some short time on 
> UPS the system does susp2disk with a time set, and boots 
> back every so often to see if power is stable.
> 
> No, I don't want susp2mem until I debug it, console come 
> up in useless mode, console as kalidescope is not what I 
> need.
> 
> Anyway, I pulled the plug on the UPS, and the system 
> shut down. But when it powered up, it booted the default 
> kernel rather than the test kernel, decided that it 
> couldn't resume, and then did a cold boot.
> 
> I can bypass this by making the debug kernel the 
> default, but WHY? 

HELL YES :-). We do not save kernel code into image.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

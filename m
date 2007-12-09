Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbXLISFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbXLISFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 13:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbXLISFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 13:05:33 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1690 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750705AbXLISFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:05:33 -0500
Date: Sun, 9 Dec 2007 17:45:20 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Warpme <warpme@o2.pl>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: S3 resume stability problems
Message-ID: <20071209174520.GI4381@ucw.cz>
References: <475460EA.4050606@o2.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475460EA.4050606@o2.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-12-03 21:02:50, Warpme wrote:
> Hi *
> 
> I'm setting up 2 appliances based on AMD x2 4400 CPU and 
> Nvidia Mobos: ASUS M2NPV-VM (6150 based) and Abit 
> AN-M2HD (7050 based). Kernel is 2.6.23.9.
> 
> My issue is stability of S3 resume:
> -on ASUS it hangs every 3-10 try and it not depends on 
> maxcpus setting.
> -on Abit also it hangs every 3-10 try, but with 
> maxcpus=1 is stable.
> 
> It is not depending on enabled HW on mobos - even with 
> all HW disabled in BIOS S3, resume is still unstable.
> 
> Observing resume process I didn't see any errors in 
> syslog. Also when resume hangs it hangs always with 
> still lightning CapsLock keyb led (keyb is not reacting 
> on CapsLock pressing) -> it leads me that it isn't video 
> issue.
> 
> As Abit with maxcpus=1 is working OK - it hints me that 
> resume issue is related to non-booting processor 
> initialization.
> 
> Do somebody can help me investigate problem ?

Try starting/stopping cpus in loop, to see if cpu hotplug works
reliably.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

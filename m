Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbZIFF1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbZIFF1v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 01:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZIFF1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 01:27:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52445 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZIFF1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 01:27:50 -0400
Date: Sun, 6 Sep 2009 07:27:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: VirginSnow@vfemail.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: kernel reboot before Decompressing Linux, after
	setting video mode
Message-ID: <20090906052745.GD1324@ucw.cz>
References: <86tyzjg3df.fsf@cmarib.ramside>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86tyzjg3df.fsf@cmarib.ramside>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-09-03 20:49:48, VirginSnow@vfemail.net wrote:
> [1.] One line summary of the problem:    
> 
>      Linux kernel 2.6.30.5 reboots after setting video mode, but
>      before issuing the "Decompressing Linux" message.

Did earlier kernels work with same config? If yes, then that's rather
nasty regression; cc rjw and see what happens :-).

								Pavel


> [2.] Full description of the problem/report:
> 
>      I just compiled a kernel from the official 2.6.30.5 sources using
>      gcc 3.4.4.  "make xconfig" was used to configure the kernel, and
>      the .config was NOT edited by hand.  EARLY_PRINTK=y in .config.
> 
>      Initial builds failed due to unresolved ".L1234" symbols.  Using
>      "make xconfig" to disable uncompilable code resulted in a
>      successful kernel build.
> 
>      Booting the resulting kernel outputs the message "Probing EDD"
>      and then reboots.  Passing "edd=on" or "edd=off" on the kernel
>      command line does not help; the kernel always reboots.
> 
>      Passing "vga=ask" allows me to select a video mode, which appears
>      to take effect properly.  Immediately after setting the video
>      mode, however, the machine reboots.
> 
>      The problem behavior is repeatable and consistent.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

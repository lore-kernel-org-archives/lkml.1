Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935216Ab0CMKj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 05:39:26 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47965 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933354Ab0CMKjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 05:39:24 -0500
Date: Sat, 13 Mar 2010 11:39:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: scary warning in atags.c -- 2.6.34-rc1
Message-ID: <20100313103913.GA9812@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Scary warning on HTC Dream:

[    0.220000] ------------[ cut here ]------------                                   
[    0.220000] WARNING: at arch/arm/kernel/atags.c:60
init_atags_procfs+0x5c/0xe8()   
[    0.220000] Modules linked in:                                                     
[    0.220000] [<c0025250>] (unwind_backtrace+0x0/0xdc) from
[<c0032e1c>] (warn_slowp)
[    0.220000] [<c0032e1c>] (warn_slowpath_common+0x4c/0x80) from
[<c000b4b8>] (init_)
[    0.220000] [<c000b4b8>] (init_atags_procfs+0x5c/0xe8) from
[<c002033c>] (do_one_i)
[    0.220000] [<c002033c>] (do_one_initcall+0x5c/0x1bc) from
[<c0008584>] (kernel_in)
[    0.220000] [<c0008584>] (kernel_init+0x94/0x148) from [<c00217b4>]
(kernel_thread)
[    0.220000] ---[ end trace 1b75b31a2719ed1c ]---                                   
[    0.230000] bio: create slab <bio-0> at 0                                          
[    0.230000] Switching to clocksource dg_timer                                      

Hmm, what are atags anyway?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

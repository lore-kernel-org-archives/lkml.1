Return-Path: <linux-kernel-owner+w=401wt.eu-S1764924AbXEWLzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764924AbXEWLzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 07:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760028AbXEWLzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 07:55:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4043 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759006AbXEWLzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 07:55:17 -0400
Date: Wed, 23 May 2007 11:54:45 +0000
From: Pavel Machek <pavel@ucw.cz>
To: makalski <makalski@csolve.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel panic during hibernation
Message-ID: <20070523115444.GA7444@ucw.cz>
References: <46526CBA.9060803@csolve.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46526CBA.9060803@csolve.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I have kernel panic message when trying to put Dell 
> Inspiron 6400 into hibernation.
> 
> The following is the message:
> 
> Process pm-hibernate (pid: 3168, threadinfo 
> ffff810013dba000, task ffff810018d0e
> 860)
> Stack: 0000000000000000 0000000000000000 
> 000001bc7e40f260 00000000000007ef
> 00000000000fdff0 ffffffff800a74aa ffff810037e206f8 
> ffffffff880777bc
> 000000001ebf7000 000000000001ebf7 000000000001enf6 
> 0000000000000000
> Call Trace:
> [<ffffffff800a74aa>] swsusp_write+0x2fa/0x440
> [<ffffffff880777bc>] :scsi_mod:scsi_schedule_eh+0x45/0x55
> [<ffffffff800a5817>] pm_suspend_disk+0x5b/0xce
> [<ffffffff800a46ec>] enter_state+0x52/0x19b
> [<ffffffff800a4898>] state_store+0x5e/0x79
> [<ffffffff800fa3f7>] sysfs_write_file+0xb9/0xe8
> [<ffffffff80016121>] vfs_write+0xce/0x174
> [<ffffffff800169b2>] sys_write+0x45/0x6e
> [<ffffffff8005b2c1>] tracesys+0xd1/0xdc
> 
> 
> Code 0f ba 6d 00 00 19 c0 85 c0 74 08 48 89 ef e8 49 c0 
> f7 ff 48
> RIP  [<ffffffff800c3099>] rw_swap_page_sync+0x1c/0xc2
> RSP <ffff810013dbbd68>
> <0>Kernel panic - not syncing: Fatal exception
> 
> 
> I am using "Linux localhost.localdomain 2.6.18-8.el5 #1 
> SMP Thu Mar 15 19:46:53 EDT 2007 x86_64 x86_64 x86_64 
> GNU/Linux", CentOs 5.
> 
> Could you please tell me if there is a fix for this 
> problem already, I couldn't find anything yet.

Try vanilla 2.6.20.
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

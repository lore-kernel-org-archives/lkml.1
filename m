Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbXLBTAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbXLBTAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbXLBS7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:59:44 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3462 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752464AbXLBS7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:59:42 -0500
Date: Sun, 2 Dec 2007 18:30:48 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Timers SMP] can this machine be helped?
Message-ID: <20071202183048.GC4721@ucw.cz>
References: <Pine.LNX.4.64.0711292144260.6673@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711292144260.6673@axis700.grange>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I've got an old 2xP-II @ 400MHz Compaq AP400 system, which I'm still 
> using. It has many peculiarities, so, I wouldn't be surprised if the 
> answer to my questions would be "sorry, the patient is rather dead than 
> alive".
> 
> Some of the problems lie in ACPI area, I tried some time ago to fix the 
> ACPI tables for these machine, but never got enough time for that. So I'm 
> still booting with acpi=noirq
> 
> Another problem is its battery is dead and it's hard soldered to the 
> mainboard (Compaq)...
> 
> It might also have some problems with one of its 3 SCSI busses.
> 
> I compiled a .24-ish kernel for it with CONFIG_NO_HZ and 
> CONFIG_HIGH_RES_TIMERS. To get the system boot at least sometimes I have 
> to specify nohz=off. Then I get

Try highres=off, too... Hehe, and even idle=poll might help.

> Pid: 0, comm: swapper Not tainted (2.6.24-rc2-g8c086340 #3)
> EIP: 0060:[<c0233d33>] EFLAGS: 00000283 CPU: 0
> EIP is at acpi_processor_idle+0x2ae/0x477
> EAX: 00000000 EBX: fffffeab ECX: 00000001 EDX: 00000001
> ESI: c7c5f2d0 EDI: 00122d9f EBP: c03ddfa8 ESP: c03ddf90
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: 081dcf88 CR3: 07e46000 CR4: 000002d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
>  [<c01053fa>] show_trace_log_lvl+0x1a/0x30
>  [<c0105f42>] show_trace+0x12/0x20

...and disable softlockup watchdog, too...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbXKZMQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbXKZMQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 07:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbXKZMQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 07:16:24 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1048 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754287AbXKZMQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 07:16:23 -0500
Date: Mon, 26 Nov 2007 11:54:18 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: nohz and strange sleep latencies
Message-ID: <20071126115417.GB4701@ucw.cz>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu> <20071119211142.GA1857@elf.ucw.cz> <20071120085704.GA19950@elte.hu> <20071120105458.GA1597@elf.ucw.cz> <20071120205454.GD10008@elte.hu> <alpine.LFD.0.9999.0711202345520.25057@localhost.localdomain> <20071120225246.GA24380@elte.hu> <20071122185238.GA1821@elf.ucw.cz> <alpine.LFD.0.9999.0711222121500.25057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711222121500.25057@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > but perhaps somehow we miss this fact and fail to turn off the lapic 
> > > clockevents drivers?
> > 
> > Ok, I guess I'm lost. If I offline second CPU, I immediately get
> > 1000Hz timer tick... is that expected?
> 
> Hmm. No. I have no idea why this is happening.
> 
> 34196 total events, 55.083 events/sec
> echo 0 >/sys/devices/system/cpu/cpu1/online
> 36073 total events, 54.679 events/sec

It happened again, this time on 2.6.24-pre-rc1 (mostly untainted).
Reboot and problem goes away... so this one is random :-(.

I'll try plug/unplug loops, perhaps that can trigger it reliably. (cpu
replug does not fix it once triggered).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

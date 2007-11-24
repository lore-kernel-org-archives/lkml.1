Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbXKXW3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbXKXW3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 17:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbXKXW3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 17:29:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51200 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbXKXW3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 17:29:16 -0500
Date: Sat, 24 Nov 2007 23:29:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: nohz and strange sleep latencies
Message-ID: <20071124222941.GA1544@elf.ucw.cz>
References: <20071119203152.GA1772@elf.ucw.cz> <20071119205555.GA28696@elte.hu> <20071119211142.GA1857@elf.ucw.cz> <20071120085704.GA19950@elte.hu> <20071120105458.GA1597@elf.ucw.cz> <20071120205454.GD10008@elte.hu> <alpine.LFD.0.9999.0711202345520.25057@localhost.localdomain> <20071120225246.GA24380@elte.hu> <20071122185238.GA1821@elf.ucw.cz> <alpine.LFD.0.9999.0711222121500.25057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711222121500.25057@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-11-22 21:29:51, Thomas Gleixner wrote:
> On Thu, 22 Nov 2007, Pavel Machek wrote:
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

Strange...

> Just to make sure what we are hunting: Do you have the same problem
> with an non-pavel-tainted 2.6.24-rc3 ?

The effect described above disappeared from both clean and
tainted-pavel trees...?

But I have verified again that time sleep 0.01 is perfectly willing to
sleep for 0.9second on untainted 2.6.24-rc3...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

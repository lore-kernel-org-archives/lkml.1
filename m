Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbZFAK0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbZFAK0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZFAKZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:25:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48515 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbZFAKZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:25:53 -0400
Date: Mon, 1 Jun 2009 12:25:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: ttyACM0: when the device dies, 2.6.30-rc7 dies, too, strange
	echo (regression)
Message-ID: <20090601102546.GA2288@elf.ucw.cz>
References: <20090601101421.GA1914@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601101421.GA1914@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I believe this worked before; on 2.6.30-rc7, when ttyACM0 dies
> (openmoko in bootloader powers off) the notebook I'm running minicom
> on dies, too :-(. For the first time, I did not catch any messages,
> I'll retry the test on console.

Nothing useful on the console...

And it gets worse: with 2.6.30-rc7, I only get echo on character N
when I type character N=1. Which is extremely confusing and basically
makes it unusable for interactive work. This definitely worked
before... but it was quite long ago.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

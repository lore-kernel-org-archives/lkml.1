Return-Path: <linux-kernel-owner+w=401wt.eu-S933921AbXEVLa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921AbXEVLa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 07:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757690AbXEVLaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 07:30:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3444 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755859AbXEVLaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 07:30:17 -0400
Date: Sun, 20 May 2007 20:01:43 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Christian Leber <christian@leber.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [BUG] acpi double resume and fail
Message-ID: <20070520200142.GB5235@ucw.cz>
References: <20070518213701.GA810@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518213701.GA810@core>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> i hit a problem with suspend to ram and especially resume.
> Hardware: Dell Latitude D810 (some Intel 915 with Intel Pentium M)
> 
> With 2.6.19.7 suspend to ram works reliable, but with 2.6.20-rc4
> it stopped working reliable.
> I still can suspend, but after the first resume it goes back to sleep
> directly again, when resuming again it works.
> After the second suspend it won't resume at all.

Try with minimal modules. Try beeping patch to see if we reach linux
on second resume.

Andrew: I have debugging hack that beeps the speaker as the first
thing in acpi resume (real mode) routine. It provides some useful
info. Maybe it is even worth including in mainline?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S933372AbXCMVZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbXCMVZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933630AbXCMVZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:25:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37708 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933372AbXCMVZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:25:05 -0400
Date: Tue, 13 Mar 2007 22:24:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suspend to RAM fault in VT when resuming
Message-ID: <20070313212457.GD12370@elf.ucw.cz>
References: <45F709F2.80504@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F709F2.80504@canonical.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi1

> I've chased one of the 'Suspend to RAM' resume problems to a specific
> line in drivers/char/vt.c, see attached 2.6.21-rc3 diff with

Has suspend/resume ever worked on that hardware?

> TRACE_RESUME() instrumentation. The macro scr_writew resolves to '*addr
> = val', which appears to be causing the problem. I've verified that the
> pointer is not NULL, but don't know if its really valid. Its pretty
> tough to tell what is happening, but on a Dell XPS it just hangs. A Dell
> Precision blinks the keyboard lights.

It is possible that video is not initialized at that point, and that
hardware goes seriously unhappy when you access non-existing vga. Does
it resume ok when you completely disable video support? 


								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

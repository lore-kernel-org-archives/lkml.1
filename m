Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbXE1N0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbXE1N0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbXE1N01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:26:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54538 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750779AbXE1N01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:26:27 -0400
Date: Mon, 28 May 2007 15:26:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
Message-ID: <20070528132625.GQ18807@elf.ucw.cz>
References: <4658B7DD.3060309@tmr.com> <20070527211434.GG3989@ucw.cz> <465A4953.7030708@tmr.com> <465AD746.7090008@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465AD746.7090008@tmr.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >That's clear, I'll have to use xen or kvm or similar which restores 
> >the system as suspended. Thanks for the clarification of the limitations.
> >
> Sorry, I wrote that late at night and quickly. I should have said 
> "design decision" rather than "limitation," For systems which don't do 
> multiple kernels it's not an issue.
> 
> I certainly would not have made the same decision, but I didn't write 
> the code. It seems more robust to save everything than to try to 
> identify what has and hasn't changed in a modular kernel.

We rely on atomic copy routine not moving inside the kernel. Yes, it
would be possible to copy it to "known good" address and gain ability
to resume different kernels. Actually it should not be _that_ hard.

									Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

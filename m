Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbZB1Ckr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbZB1Ckr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZB1Cki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 21:40:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486AbZB1Ckh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 21:40:37 -0500
Date: Fri, 27 Feb 2009 18:39:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: me@felipebalbi.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: ...)
Message-Id: <20090227183949.90f231e6.akpm@linux-foundation.org>
In-Reply-To: <200902271830.37207.david-b@pacbell.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	<20090227153204.fc9c579c.akpm@linux-foundation.org>
	<20090227160110.8cf8cd6e.akpm@linux-foundation.org>
	<200902271830.37207.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 18:30:36 -0800 David Brownell <david-b@pacbell.net> wrote:

> > ah, OK, twl4030_i2c_read_u8() does i2c I/O.
> > 
> > Can't do that. 
> 
> Threaded IRQ handlers *can* do that.  That's the point.
> 
> Now, if you were to say "keep waiting a few more years
> until some threaded IRQ framework finally merges" ...
> the question comes up, "What to do in the meanwhile".
> (Ditto, "well, we've been waiting a long time now to
> see those threaded IRQs, what's up with them?")

I don't have a clue what you're talking about.  Where is this "threaded
irq handler" implementation of which you speak?  File and line?


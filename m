Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYFWOUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYFWOUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYFWOUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:20:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1165 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753213AbYFWOUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:20:07 -0400
Date: Mon, 23 Jun 2008 16:19:55 +0200
From: Pavel Machek <pavel@suse.cz>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Fwd: Recommendation for activating a deferred module init in the kernel]
Message-ID: <20080623141955.GA5006@ucw.cz>
References: <4858024D.6010601@am.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4858024D.6010601@am.sony.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> In our modification, we:
>  1) add another phase for deferred initcalls
>  2) modify the module_init macro definition to use that phase, for the
>  modules we wish to defer initialization of
>  3) modify the free code to not free the memory until later
>  4) add an ioctl to trigger the deferred initialization (and memory free)
> 
> One of the main sub-systems that we defer initialization of this
> way is USB, and this saves quite a bit of time.  (Of course the
> same, or slightly more CPU cycles are eventually used during
> bootup time.  But this lets us get to user space quicker so we
> can start user-visible applications faster.)

Could the usb be modified to do background init by default, instead?

> I'm not that happy using an ioctl for this trigger.  What is
> the preferred method of activating a kernel feature like this?
> I presume something in /proc or /sys, but I'm not sure.

Definitely not /proc.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

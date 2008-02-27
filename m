Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbYB0JjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbYB0JjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 04:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYB0Ji4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 04:38:56 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4340 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751107AbYB0Jin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 04:38:43 -0500
Date: Wed, 27 Feb 2008 10:19:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: boot_delay broken ?
Message-ID: <20080227091950.GA4615@ucw.cz>
References: <20080224004615.GA31012@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224004615.GA31012@codemonkey.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-02-23 19:46:15, Dave Jones wrote:
> The boot_delay switch seems to be behaving strangely in the
> current -git.  Setting it to =10 makes the output 'bursty'
> it becomes slow for some printk's whilst others scroll by
> at regular speed.
> Setting it any higher than that seems to make it pause for
> a really long time before it outputs any text at all.
> 
> x86 timer changes perhaps ?

If nohz=off highres=off notsc fixes it, it is probably timers :-).


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

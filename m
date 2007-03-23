Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbXCWMWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbXCWMWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 08:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXCWMWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 08:22:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60069 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752595AbXCWMWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 08:22:07 -0400
Date: Fri, 23 Mar 2007 13:21:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>
Subject: Re: [linux-pm] [patch 2/2] clk_must_disable() implementation on AT91
Message-ID: <20070323122158.GE9667@elf.ucw.cz>
References: <200703221108.21861.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703221108.21861.david-b@pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This supports the new clk_must_disable() interface for AT91 systems:
> 
>  - Implement the call, replacing at91_suspend_entering_slow_clock()
>    and eliminating various "that's not exported" build warnings;
> 
>  - Use it in three drivers: USB Host, USB Peripheral, and RS232 serial.
> 
> Briefly, those are three of the drivers that need to act differently when
> going into deeper sleep states (suspend-to-RAM, vs standby), since among
> other things they can't act as wakeup event sources without using the
> clocks which are disabled in those deeper sleep states.
> 
> (The at91_ethernet driver would be another such driver, but it doesn't
> currently implement wake-on-LAN even in the "standby" mode.)
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

FWIW, it looks okay to me. But you probably need to cc akpm if you
want it merged...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

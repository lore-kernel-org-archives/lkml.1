Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbZFKUcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbZFKUcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 16:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbZFKUck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 16:32:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40445 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZFKUcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 16:32:39 -0400
Date: Thu, 11 Jun 2009 22:32:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.30: hibernation/swsusp stuck in disable_nonboot_cpus
Message-ID: <20090611203234.GA27376@elf.ucw.cz>
References: <20090611165608.GA4908@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611165608.GA4908@sig21.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 18:56:08, Johannes Stezenbach wrote:
> Hi,
> 
> on my work machine susend-to-disk is broken in 2.6.30.  Last
> known working kernel was 2.6.29.1. I'm running a 32bit kernel.
> CPU is an AMD Athlon(tm) Dual Core Processor 4850e.
> Board is a Gigabyte GA-MA78GM-S2H rev 1.1.
> 
> - usually it stops on suspend after the message
>   "Suspending console(s) (use no_console_suspend to debug)"
> 
> - I booted with no_console_suspend using serial console
>   as recommended in Documentation/power/basic-pm-debugging.txt.
> 
>   No joy, apparently the serial driver is disabled during suspend
>   and no interesting output on serial console...
> 
> - no_console_suspend on VESA fb console worked better, last msg is
>   "Disabling non-boot CPUs ..."
...
> Kernel config, dmesg and lspci below.  Is there anyting I could
> try besides git bisect?

Trying to set CONFIG_SMP=n and reproducing? Trying hibernating after
manually offlining CPU?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

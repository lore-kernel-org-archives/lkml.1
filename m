Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbYFAOqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbYFAOqD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYFAOpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:45:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4286 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752721AbYFAOpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:45:04 -0400
Date: Sat, 31 May 2008 09:44:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Bug 10797] Something is consuming power after shutdown
Message-ID: <20080531074433.GE5405@ucw.cz>
References: <483AB443.6020807@diamondcut.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483AB443.6020807@diamondcut.com.br>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
> <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=481493>
> 
> After poweroff, something still working and consuming 
> power. So I loss ~4% of my battery charge in each 12h.
> 
> If I shutdown my laptop using Kernel 2.6.24/25 when 
> battery is 100%, after 12h my battery charge go to 96% 
> (this information is checked with kpowersave and with 
> LED available in my laptop that change color from blue 
> to yellow when battery is not FULL).
> 
> If I shutdown this same laptop by WinXP (I have a dual 
> boot), nothing change. So, my battery still have 100% 
> after 12h (or more).

Try to find out which component eats power, eg. by opening the machine
searching for heat.

(And yes, your hw is broken; on pc it is traditionaly hw
responsibility to power machine down.)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

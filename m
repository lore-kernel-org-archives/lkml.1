Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYH0Vjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYH0Vjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYH0Vji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:39:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690AbYH0Vjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:39:37 -0400
Date: Wed, 27 Aug 2008 14:39:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Wim Van Sebroeck <wim@iguana.be>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: v2.6.27-rc4 watchdog patches
In-Reply-To: <20080826203648.GC2763@infomag.infomag.iguana.be>
Message-ID: <alpine.LFD.1.10.0808271437560.3363@nehalem.linux-foundation.org>
References: <20080826203648.GC2763@infomag.infomag.iguana.be>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Wim Van Sebroeck wrote:
> 
>  drivers/watchdog/Kconfig          |   24 ++
>  drivers/watchdog/Makefile         |    3 
>  drivers/watchdog/at91rm9200_wdt.c |    2 
>  drivers/watchdog/hpwdt.c          |   93 +++++-----
>  drivers/watchdog/mpc8xx_wdt.c     |  170 ------------------
>  drivers/watchdog/mpc8xxx_wdt.c    |   11 +
>  drivers/watchdog/pc87413_wdt.c    |    1 
>  drivers/watchdog/rc32434_wdt.c    |  344 ++++++++++++++++++++++++++++++++++++++
>  drivers/watchdog/rdc321x_wdt.c    |  285 +++++++++++++++++++++++++++++++
>  drivers/watchdog/s3c2410_wdt.c    |   16 -
>  10 files changed, 714 insertions(+), 235 deletions(-)

Ok, I'm going to ask you to not send new watchdog drivers after the merge 
window.

There really is no upside. Nobody is going to be inconvenienced by a lack 
of a watchdog driver int he same way that it's a problem if a disk driver 
or a network driver is missing.

I pulled it, but please consider new drivers to be a "merge window only" 
thing in the future.

		Linus

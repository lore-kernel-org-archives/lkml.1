Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYIWLUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYIWLUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYIWLT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:19:57 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:61697 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbYIWLT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:19:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAFds2EhR9cQt/2dsb2JhbACBXbV+gWY
Date: Tue, 23 Sep 2008 13:19:54 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>, Alan Cox <alan@redhat.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: How to kick a secondary watchdog? (Re: [PATCH 1/3] watchdog: sync linux-omap changes)
Message-ID: <20080923111954.GU22550@infomag.infomag.iguana.be>
References: <1221873243-18303-1-git-send-email-me@felipebalbi.com> <1221873243-18303-2-git-send-email-me@felipebalbi.com> <20080922182206.GM22550@infomag.infomag.iguana.be> <20080922191353.GB8314@flint.arm.linux.org.uk> <20080923083915.GS22550@infomag.infomag.iguana.be> <20080923102159.GD5102@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923102159.GD5102@atomide.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

> Wim, while at it, here's a related omap_wdt question:
> 
> Some omap devices like Nokia 770, N800 and N810 have also a secondary
> watchdog on the retu chip connected via cbus. This watchdog needs
> to be kicked as it cannot be disabled.
> 
> We've been thinking of adding a function that omap_wdt can
> call to also kick retu_wdt too as there is only one wdt interface.
> 
> Is there some better solution available?

Plan is to go to a uniform watchdog driver first, then add sysfs
capabilities and then we can add more devices via sysfs.
For the time being: I would kick both of them at the same time
via the /dev/watchdog interface.

Regards,
Wim.


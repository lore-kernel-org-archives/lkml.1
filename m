Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYIWIj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYIWIj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 04:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYIWIjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 04:39:21 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:54142 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbYIWIjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 04:39:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEANdG2EhR9cQt/2dsb2JhbACBXbUzgWY
Date: Tue, 23 Sep 2008 10:39:15 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>, Alan Cox <alan@redhat.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH 1/3] watchdog: sync linux-omap changes
Message-ID: <20080923083915.GS22550@infomag.infomag.iguana.be>
References: <1221873243-18303-1-git-send-email-me@felipebalbi.com> <1221873243-18303-2-git-send-email-me@felipebalbi.com> <20080922182206.GM22550@infomag.infomag.iguana.be> <20080922191353.GB8314@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922191353.GB8314@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

> It's unused, but it's a minor point, something that shouldn't stand
> in the way of it going into the watchdog tree.  It doesn't cause a
> build error and doesn't cause malfunction.  It's just a little untidy
> and can be addressed separately.

We will need to address it later then. I just added the patches to the
linux-2.6-watchdog-mm tree.

> +               omap_wdt_set_timeout(wdev);
> +               omap_wdt_enable(wdev);
>                 spin_unlock(&wdt_lock);
> +
> +               omap_wdt_ping(wdev);
> 
> which is moving omap_wdt_ping() outside of the spin lock, which I
> doubt actually causes any problem in real life on OMAP platforms.
> Granted that theoretically and logically it's wrong.

And since this is indeed wrong, I changed this back.

Kind regards,
Wim.


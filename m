Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbYIVSYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbYIVSYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYIVSWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:22:16 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:50184 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754125AbYIVSWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:22:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAJ9/10hR9cHm/2dsb2JhbACBXbZBgWY
Date: Mon, 22 Sep 2008 20:22:06 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>, Alan Cox <alan@redhat.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH 1/3] watchdog: sync linux-omap changes
Message-ID: <20080922182206.GM22550@infomag.infomag.iguana.be>
References: <1221873243-18303-1-git-send-email-me@felipebalbi.com> <1221873243-18303-2-git-send-email-me@felipebalbi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221873243-18303-2-git-send-email-me@felipebalbi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

last item that (for me) is still open is:
> +struct omap_wdt_dev {
> +	void __iomem    *base;          /* physical */
> +	struct device   *dev;

is dev indeed unused or is it used by platform specific code?
If this is sorted out this will go into the watchdog-mm tree.

Kind regards,
Wim.


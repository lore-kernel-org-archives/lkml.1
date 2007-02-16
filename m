Return-Path: <linux-kernel-owner+w=401wt.eu-S1946240AbXBPTY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946240AbXBPTY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946239AbXBPTY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:24:58 -0500
Received: from gw.goop.org ([64.81.55.164]:46764 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946221AbXBPTY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:24:57 -0500
Message-ID: <45D60508.10000@goop.org>
Date: Fri, 16 Feb 2007 11:24:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Keir Fraser <keir@xensource.com>
CC: xen-devel@lists.xensource.com, Andi Kleen <ak@muc.de>,
       linux-kernel@vger.kernel.org, Ian Pratt <Ian.Pratt@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Hand <steven.hand@cl.cam.ac.uk>,
       Christian Limpach <Christian.Limpach@xensource.com>
Subject: Re: [Xen-devel] Re: [patch 14/21] Xen-paravirt: Add XEN config options
 and disableunsupported config options.
References: <C1FBAFD7.99AB%keir@xensource.com>
In-Reply-To: <C1FBAFD7.99AB%keir@xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> We can extend the Xen timer interface quite easily and get rid of this one
> too. In fact it doesn't *much* matter if the CONFIG_HZ differs from the Xen
> ticker rate -- we modified the Linux timer ISR to handle timer interrupts at
> arbitrary times already. The only drawback is that jiffies updates in burts
> if CONFIG_HZ is higher than the actual tick rate, and this can affect some
> calibration constants and cause Linux to print out some weird values at
> start-of-day.
>   

I was wondering what would happen if we tried that.  I guess its
equivalent to having stolen time between each Xen tick.

    J

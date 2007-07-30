Return-Path: <linux-kernel-owner+w=401wt.eu-S934662AbXG3NcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934662AbXG3NcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 09:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbXG3NcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 09:32:05 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:53583 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753109AbXG3NcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 09:32:04 -0400
Date: Mon, 30 Jul 2007 15:31:39 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Steve Grubb <sgrubb@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-audit@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/audit.c: change the exports to
	EXPORT_SYMBOL_GPL
Message-ID: <20070730133139.GR16817@stusta.de>
References: <20070729150233.GX16817@stusta.de> <200707300918.41408.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200707300918.41408.sgrubb@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 09:18:41AM -0400, Steve Grubb wrote:
> On Sunday 29 July 2007 11:02:33 Adrian Bunk wrote:
> > They are still completely unused, but hopefully some of the theoretical
> > code that might use it will appear in the kernel in the near future...
> >
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > Acked-by: Steve Grubb <sgrubb@redhat.com>
> 
> I am reluctant to say that I ack this patch for a couple reasons:
> 
> 1) We are talking about a basic logging facility that should be open like 
> printk() is.
> 
> 2) There are no user space GPL restrictions to use the audit netlink API, so 
> why restrict who can send audit events via the in-kernel interfaces? It just 
> doesn't make sense to have 2 different licenses for in-kernel vs user space 
> audit event recording. Its the same subsystem differing only by where the 
> event originated.

It's a well-known fact that there are legal differences between calling 
kernel services from userspace and kernel modules.

> 3) The API has been unrestricted for years. I don't think its a good idea to 
> take a basic logging API away from people that have programmed to it.

If it's such a basic API, why isn't there a single user in the kernel?

> 4) In the absence of the in-kernel audit logging api, people will either 
> create parallel infrastructure or resort to using printk. It will be 
> difficult for end users to correlate security events from 2 different logs.
> 
> I would support there being a mechanism for anyone who wants to reduce the 
> number of exported symbols for their own kernels - I believe that is the 
> basic problem here. But I think there are enough reasons to continue keeping 
> this API open and unrestricted for anyone that wants it that way.

The Linux kernel does not offer a stable kernel API for external modules.
That's a well-known fact.

> -Steve

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


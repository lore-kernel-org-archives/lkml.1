Return-Path: <linux-kernel-owner+w=401wt.eu-S1423268AbXBPGt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423268AbXBPGt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423312AbXBPGt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:49:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54362 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423268AbXBPGtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:49:55 -0500
Date: Thu, 15 Feb 2007 22:48:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 17/21] Xen-paravirt: Add the Xen virtual console driver.
Message-Id: <20070215224850.1d122b58.akpm@linux-foundation.org>
In-Reply-To: <20070216022531.825832971@goop.org>
References: <20070216022449.739760547@goop.org>
	<20070216022531.825832971@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 18:25:06 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> ===================================================================
> --- a/arch/i386/kernel/early_printk.c
> +++ b/arch/i386/kernel/early_printk.c
> @@ -1,2 +1,4 @@
>  
> +#ifndef CONFIG_XEN
>  #include "../../x86_64/kernel/early_printk.c"
> +#endif
> ===================================================================

This can be done in Kconfig: disable CONFIG_EARLY_PRINTK if CONFIG_XEN.

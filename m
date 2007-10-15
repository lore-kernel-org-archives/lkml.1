Return-Path: <linux-kernel-owner+w=401wt.eu-S1764815AbXJOTPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764815AbXJOTPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbXJOTPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:15:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49735 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756963AbXJOTPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:15:40 -0400
Date: Mon, 15 Oct 2007 12:15:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gilles Gigan <gilles.gigan@bluebottle.com>
Cc: gilles.gigan@bluebottle.com, linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH] watchdog: add Nano 7240 driver
Message-Id: <20071015121516.5067a462.akpm@linux-foundation.org>
In-Reply-To: <200710071249.l97CnAYC021425@mi1.bluebottle.com>
References: <200710061539.l96FddWs002059@mi1.bluebottle.com>
	<20071007070832.GA13090@pazke.donpac.ru>
	<200710071249.l97CnAYC021425@mi1.bluebottle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Oct 2007 22:49:00 +1000
Gilles Gigan <gilles.gigan@bluebottle.com> wrote:

> Andrey Panin wrote:
> >> +#ifdef CONFIG_WATCHDOG_NOWAYOUT
> >> +#define NOWAYOUT			1
> >> +#else
> >> +#define NOWAYOUT			0
> >> +#endif
> >> +static int nowayout = NOWAYOUT;
> > 
> > You don't need this #ifdef crap. Just use WATCHDOG_NOWAYOUT instead.
> 
> done
> 
> 
> >> +	if ((_IOC_DIR(cmd) & _IOC_READ) &&
> >> +	    (!access_ok(VERIFY_WRITE, (void __user *)arg, _IOC_SIZE(cmd))))
> >> +		return -EFAULT;
> >> +	if ((_IOC_DIR(cmd) & _IOC_WRITE) &&
> >> +	    (!access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd))))
> >> +		return -EFAULT;
> > 
> > Is this really needed ?
> 
> removed
> 
> Signed-off-by: Gilles Gigan <gilles.gigan@bluebottle.com>
> ---
> 
> diff -uprN -X linux-2.6.23-rc9/Documentation/dontdiff 
> linux-2.6.23-rc9/drivers/char/watchdog/Kconfig 
> linux-2.6.23-rc9-dirty/drivers/char/watchdog/Kconfig

Could you please send a new version of this patch which has
a changelog, isn't space-stuffed and isn't wordwrapped?

Thanks.

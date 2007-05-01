Return-Path: <linux-kernel-owner+w=401wt.eu-S1423649AbXEAVMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423649AbXEAVMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423661AbXEAVMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:12:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37364 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423633AbXEAVMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:12:48 -0400
Date: Tue, 1 May 2007 22:12:43 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [patch 29/33] SONIC interrupt handling
Message-ID: <20070501211243.GA27018@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Finn Thain <fthain@telegraphics.com.au>
References: <20070501203234.252205858@mail.of.borg> <20070501203337.746958387@mail.of.borg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501203337.746958387@mail.of.borg>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 10:33:03PM +0200, Geert Uytterhoeven wrote:
> +static int jazzsonic_open(struct net_device* dev) {
> +	if (request_irq(dev->irq, &sonic_interrupt, IRQF_DISABLED, "sonic", dev)) {
> +		printk(KERN_ERR "\n%s: unable to get IRQ %d.\n", dev->name, dev->irq);
> +		return -EAGAIN;
> +	}
> +	return sonic_open(dev);
> +}

Opening brace for a function on a line of it's own please.

Also starting a printk with '\n' seems rather odd.


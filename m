Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZDMErD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZDMErD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 00:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZDMEqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 00:46:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44905 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbZDMEqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 00:46:51 -0400
Date: Mon, 13 Apr 2009 00:46:43 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parport: Use the PCI IRQ if offered
Message-ID: <20090413044643.GA6072@bombadil.infradead.org>
References: <20090407143009.31233.22016.stgit@t61.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407143009.31233.22016.stgit@t61.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 03:30:57PM +0100, Alan Cox wrote:
> PCI parallel port devices can IRQ share so we should stop them hogging the
> line and making a mess on modern PC systems. We know the sharing side works
> as the PCMCIA driver has shared the parallel port IRQ for some time.
> 
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>

> +extern struct parport *parport_pc_probe_port(unsigned long base,
> +					     unsigned long base_hi,
> +					     int irq, int dma,
> +					     struct device *dev,
> +					     int irqflags);
> +extern void parport_pc_unregister_port(struct parport *p);
>  

You missed a bunch of uses of parport_pc_probe_port and broke the build
on powerpc, sparc, parisc, and probably several more.

regards, Kyle

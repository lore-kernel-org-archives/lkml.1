Return-Path: <linux-kernel-owner+w=401wt.eu-S1161728AbXD1Imd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161728AbXD1Imd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 04:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161725AbXD1Imd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 04:42:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48414 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161706AbXD1Imb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 04:42:31 -0400
Date: Sat, 28 Apr 2007 09:42:25 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] h8300 generic irq
Message-ID: <20070428084225.GA22480@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	lkml <linux-kernel@vger.kernel.org>
References: <m2abwvttya.wl%ysato@users.sourceforge.jp> <20070427190935.68606a3a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427190935.68606a3a.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 07:09:35PM -0700, Andrew Morton wrote:
> > +/*
> > + * h8300 interrupt controler implementation
> > + */
> > +struct irq_chip h8300irq_chip = {
> > +	.name		= "H8300-INTC",
> > +	.startup	= h8300_startup_irq,
> > +	.shutdown	= h8300_shutdown_irq,
> > +	.enable		= h8300_enable_irq,
> > +	.disable	= h8300_disable_irq,
> > +	.ack		= NULL,
> > +	.end		= h8300_end_irq,
> > +};
> 
> I think this could have static scope.

Pluse there's not need to set .ack to NULL explicitly.


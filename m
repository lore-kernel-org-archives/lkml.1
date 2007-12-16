Return-Path: <linux-kernel-owner+w=401wt.eu-S932556AbXLPKJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbXLPKJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 05:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765667AbXLPKJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 05:09:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58683 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765489AbXLPKJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 05:09:17 -0500
Date: Sun, 16 Dec 2007 10:09:13 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>, Adrian McMenamin <lkmladrian@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-sh@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 2/3] Add GD-Rom support to the SEGA Dreamcast
Message-ID: <20071216100913.GA1208@infradead.org>
References: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com> <20071216095019.GA12184@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071216095019.GA12184@linux-sh.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 06:50:19PM +0900, Paul Mundt wrote:
> > +static irqreturn_t gdrom_command_interrupt(int irq, void *dev_id)
> > +{
> > +	if (dev_id != &gd)
> > +		return IRQ_NONE;
> 
> You aren't setting this up as a shared IRQ, so this shouldn't be
> necessary.

It's not nessecary for shared irqs either.  The irq code will never
pass you a different cookied back than the one you passed in.
Everything else would be a nighmare and these cargo cult workarounds
wouldn't help either.


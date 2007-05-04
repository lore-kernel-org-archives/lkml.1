Return-Path: <linux-kernel-owner+w=401wt.eu-S1767315AbXEDLHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767315AbXEDLHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767468AbXEDLHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:07:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32920 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767315AbXEDLHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:07:00 -0400
Date: Fri, 4 May 2007 12:06:55 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, gerg@uclinux.org
Subject: Re: [PATCH] m68knommu: use generic irq framework
Message-ID: <20070504110655.GA2936@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org,
	gerg@uclinux.org
References: <200705040013.l440DGjB011704@goober>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705040013.l440DGjB011704@goober>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> --- linux-2.6.21/arch/m68knommu/kernel/irq.c	1970-01-01 10:00:00.000000000 +1000
> +++ linux-2.6.21-gt/arch/m68knommu/kernel/irq.c	2007-05-04 00:20:44.000000000 +1000
> @@ -0,0 +1,82 @@
> +/*
> + * arch/m68knommu/kernel/irq.c

No need for top of file filename comments, they don't provide anything
but easily get out of sync.


Except for that little nitpick the patch looks very good to me,
thanks a lot for doing the conversion.

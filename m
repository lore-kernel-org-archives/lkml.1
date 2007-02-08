Return-Path: <linux-kernel-owner+w=401wt.eu-S1423287AbXBHTmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423287AbXBHTmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423279AbXBHTmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:42:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57163 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423276AbXBHTmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:42:10 -0500
Date: Thu, 8 Feb 2007 19:42:04 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] ATA convert GSI to irq on ia64
Message-ID: <20070208194204.GC2354@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
References: <1170920422.15989.354.camel@ymzhang>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170920422.15989.354.camel@ymzhang>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 03:40:22PM +0800, Zhang, Yanmin wrote:
> If an ATA drive uses legacy mode, ata driver will choose 14 and 15 as the
> fixed irq number. On ia64 platform, such numbers are GSI and should be converted
> to irq vector.
> 
> Below patch against kernel 2.6.20 fixes it.

These direct arch ifdefs in core aren't acceptable.  The again I'm
pretty sure we have patches floating around to turn these two macros
into architecture-supplied ones, IIRC it came from the powerpc side.


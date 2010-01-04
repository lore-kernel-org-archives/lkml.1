Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367Ab0ADSMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0ADSMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035Ab0ADSM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:12:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40289 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0ADSM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:12:28 -0500
Date: Mon, 4 Jan 2010 13:12:28 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] VLYNQ: add missing linux/irq.h include
Message-ID: <20100104181228.GA28990@infradead.org>
References: <201001041838.51265.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001041838.51265.florian@openwrt.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 06:38:51PM +0100, Florian Fainelli wrote:
> This patch adds the missing linux/irq.h header
> which will trigger compilation errors on non-AR7
> platforms (i.e: TI Davinci).

linux/irq.h should not be included by drivers.  It's an internal handler
for the generic hardirq code.  All functions for use by drivers are in
linux/interrupt.h


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762491AbXKHSOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762491AbXKHSOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762343AbXKHSOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:14:30 -0500
Received: from havoc.gtf.org ([69.61.125.42]:54308 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761744AbXKHSO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:14:29 -0500
Date: Thu, 8 Nov 2007 13:14:28 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Paul Mundt <lethal@linux-sh.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH 1/2 take #2] libata: Support PIO polling-only hosts.
Message-ID: <20071108181428.GF3491@havoc.gtf.org>
References: <20071108021456.GA30648@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071108021456.GA30648@linux-sh.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 11:14:56AM +0900, Paul Mundt wrote:
> By default ata_host_activate() expects a valid IRQ in order to
> successfully register the host. This patch enables a special case
> for registering polling-only hosts that either don't have IRQs
> or have buggy IRQ generation (either in terms of handling or
> sensing), which otherwise work fine.
> 
> Hosts that want to use polling mode can simply set ATA_FLAG_PIO_POLLING
> and pass in an invalid IRQ.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 

applied 1-2


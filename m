Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYBKTbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYBKTbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758453AbYBKTbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:31:45 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55311 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758389AbYBKTbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:31:44 -0500
Message-ID: <47B0A29C.6000508@pobox.com>
Date: Mon, 11 Feb 2008 14:31:40 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Byron Bradley <byron.bbradley@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, saeed@marvell.com,
       mlord@pobox.com
Subject: Re: [PATCH] sata_mv: platform driver allocs dma without create
References: <alpine.DEB.1.00.0802102117150.9668@git.byronbradley.co.uk>
In-Reply-To: <alpine.DEB.1.00.0802102117150.9668@git.byronbradley.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Byron Bradley wrote:
> When the sata_mv driver is used as a platform driver,
> mv_create_dma_pools() is never called so it fails when trying
> to alloc in mv_pool_start().
> 
> Signed-off-by: Byron Bradley <byron.bbradley@gmail.com>
> Acked-by: Mark Lord <mlord@pobox.com>
> ---
> 
> Mark, based on the comment from Andrew Morton on the "sata_mv: fix loop
> with last port" patch I have changed your Signed-off-by to an Acked-by.
> Hopefully thats correct.

applied



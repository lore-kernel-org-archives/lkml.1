Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbYIRQSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbYIRQSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbYIRQSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:18:03 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:42388 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbYIRQSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:18:01 -0400
Date: Thu, 18 Sep 2008 18:16:56 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Timur Tabi <timur@freescale.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dmatest: properly handle duplicate DMA channels
Message-ID: <20080918181656.6ff00a14@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <1221754217-26974-1-git-send-email-timur@freescale.com>
References: <1221754217-26974-1-git-send-email-timur@freescale.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 18 Sep 2008 16:16:46.0582 (UTC) FILETIME=[F2863960:01C919A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi <timur@freescale.com> wrote:
> Update the the dmatest driver so that it handles duplicate DMA channels
> properly.
> 
> When a DMA client is notified of an available DMA channel, it must check if it
> has already allocated resources for that channel.  If so, it should return
> DMA_DUP.  This can happen, for example, if a DMA driver calls
> dma_async_device_register() more than once.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

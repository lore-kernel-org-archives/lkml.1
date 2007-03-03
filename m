Return-Path: <linux-kernel-owner+w=401wt.eu-S2992814AbXCCAni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992814AbXCCAni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 19:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992812AbXCCAni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 19:43:38 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55237 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992809AbXCCAnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 19:43:37 -0500
Message-ID: <45E8C4B6.4050302@garzik.org>
Date: Fri, 02 Mar 2007 19:43:34 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Gary Zambrano <zambrano@broadcom.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] dma-mapping.h
References: <1171651858.16919.14.camel@dhcp-10-7-81-58.broadcom.com>
In-Reply-To: <1171651858.16919.14.camel@dhcp-10-7-81-58.broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Zambrano wrote:
> Added dma_sync_single_range_for_cpu/device to dma-mapping.h in asm-arm &
> asm-avr32 to call dma_sync_single_for_cpu/device. This patch enables b44
> to compile on systems with these cpus.
> This patch was created with the assumption that another method of
> dma_sync_single_range_for_cpu/device does not exist on these
> architectures.
> 
> 
> Signed-off by: Gary Zambrano <zambrano@broadcom.com>

this patch looks OK to me, but I'm not the one to apply it.  This should 
go through Andrew or linux-arch

	Jeff, passing the buck




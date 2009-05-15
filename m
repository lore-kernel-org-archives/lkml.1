Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbZEOSRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbZEOSRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761406AbZEOSQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:16:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39751 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757631AbZEOSQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:16:44 -0400
Message-ID: <4A0DB188.9000708@garzik.org>
Date: Fri, 15 May 2009 14:16:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3] sata_fsl: Fix compile warnings
References: <1242270650-27945-1-git-send-email-galak@kernel.crashing.org>
In-Reply-To: <1242270650-27945-1-git-send-email-galak@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> We we build with dma_addr_t as a 64-bit quantity we get:
> 
> drivers/ata/sata_fsl.c: In function 'sata_fsl_fill_sg':
> drivers/ata/sata_fsl.c:340: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'dma_addr_t'
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> * v2: fixed extra 'x'
> * v3: fixed whitespace issue
> 
>  drivers/ata/sata_fsl.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)

applied



Return-Path: <linux-kernel-owner+w=401wt.eu-S1763544AbYEVVVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763544AbYEVVVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761248AbYEVVUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:20:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49697 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765118AbYEVVUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:20:44 -0400
Message-ID: <4835E39E.90801@garzik.org>
Date: Thu, 22 May 2008 17:20:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jay Cliburn <jacliburn@bellsouth.net>, stable@kernel.org
Subject: Re: [PATCH RESEND] atl1: fix 4G memory corruption bug
References: <20080522220025.GA566@martell.zuzino.mipt.ru>
In-Reply-To: <20080522220025.GA566@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> From: Alexey Dobriyan <adobriyan@gmail.com>
> 
> When using 4+ GB RAM and SWIOTLB is active, the driver corrupts
> memory by writing an skb after the relevant DMA page has been
> unmapped.  Although this doesn't happen when *not* using bounce
> buffers, clearing the pointer to the DMA page after unmapping
> it fixes the problem.
> 
> http://marc.info/?t=120861317000005&r=2&w=2
> 
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> ---
> 
>  drivers/net/atlx/atl1.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

applied



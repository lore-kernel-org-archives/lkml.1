Return-Path: <linux-kernel-owner+w=401wt.eu-S1762303AbXJRAVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303AbXJRAVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbXJRAVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:21:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49903 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbXJRAVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:21:15 -0400
Message-ID: <4716A6F2.60807@garzik.org>
Date: Wed, 17 Oct 2007 20:21:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, shemminger@linux-foundation.org
Subject: Re: [patch] forcedeth: fix the NAPI poll function, take #2
References: <20071015112430.GA30006@elte.hu> <20071015.125731.79447899.davem@davemloft.net> <20071015220357.GA7174@elte.hu> <20071015220720.GA16101@elte.hu> <20071015223009.GA27425@elte.hu> <47152B32.9020905@pobox.com> <20071017072551.GD18044@elte.hu> <20071017101823.GA4573@elte.hu>
In-Reply-To: <20071017101823.GA4573@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> I'll send upstream today unless people scream...
> 
> albeit you forgot to merge half of my patch :-/ The (tested) patch below 
> fixes that.
> 
> 	Ingo
> 
> ---------------->
> Subject: forcedeth: fix rx-work condition in nv_rx_process_optimized() too
> From: Ingo Molnar <mingo@elte.hu>
> 
> the merge of my previous fix to forcedeth.c lots an important hunk.
> 
> this patch fixes that.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/net/forcedeth.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

applied



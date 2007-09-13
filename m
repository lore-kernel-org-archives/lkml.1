Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbXIMORA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbXIMORA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbXIMOQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:16:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50493 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbXIMOQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:16:50 -0400
Message-ID: <46E9464A.2020905@pobox.com>
Date: Thu, 13 Sep 2007 10:16:42 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Micah Gruber <micah.gruber@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [CORRECTION][PATCH] Fix a potential NULL pointer dereference
 in uli526x_interrupt() in drivers/net/tulip/uli526x.c
References: <46DD13CE.6010905@gmail.com> <20070913020346.979647c1.akpm@linux-foundation.org>
In-Reply-To: <20070913020346.979647c1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> --- a/drivers/net/tulip/uli526x.c~fix-a-potential-null-pointer-dereference-in-uli526x_interrupt
> +++ a/drivers/net/tulip/uli526x.c
> @@ -666,11 +666,6 @@ static irqreturn_t uli526x_interrupt(int
>  	unsigned long ioaddr = dev->base_addr;
>  	unsigned long flags;
>  
> -	if (!dev) {
> -		ULI526X_DBUG(1, "uli526x_interrupt() without DEVICE arg", 0);
> -		return IRQ_NONE;
> -	}
> -


correct / ACK


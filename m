Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbYG3VPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbYG3VPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbYG3VPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:15:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33652 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221AbYG3VPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:15:30 -0400
Message-ID: <4890D9EA.5080401@garzik.org>
Date: Wed, 30 Jul 2008 17:15:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc1]: fix NE2000 linkage error
References: <200807301144.m6UBitOG022822@harpo.it.uu.se>
In-Reply-To: <200807301144.m6UBitOG022822@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Trying to build with CONFIG_NE2000=m fails with:
> 
>   scripts/mod/modpost   -o /tmp/tmp/linux-2.6.27-rc1/Module.symvers    -S     -s
> ERROR: "NS8390_init" [drivers/net/ne.ko] undefined!
> 
> This is because the split of 8390 into pausing and non-pausing
> versions was incompletely propagated to ne.c. This fixes it.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

actually, I take that back, I still needed a bit of this.  thanks



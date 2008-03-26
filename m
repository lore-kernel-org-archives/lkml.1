Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYCZDsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYCZDsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYCZDsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:48:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39358 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbYCZDsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:48:23 -0400
Message-ID: <47E9C784.6050807@garzik.org>
Date: Tue, 25 Mar 2008 23:48:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: yang.shi@windriver.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improvev netconsole support for RTL8139 NIC driver
References: <47E9B39C.5010502@pobox.com>	<20080325.194221.16658596.davem@davemloft.net>	<47E9BF7B.3030003@pobox.com> <20080325.203043.196469543.davem@davemloft.net> <47E9C56F.2070508@pobox.com>
In-Reply-To: <47E9C56F.2070508@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> I am being realistic...  it's
> 
> * not needed
> * increases code size
> * increases number of CPU instructions executed
> * not needed

I also wonder if using spin_lock_irqsave() makes moving to a real-time 
kernel with interrupt threads more difficult for that driver.

And of course we're talking about a hot path here.

	Jeff



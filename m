Return-Path: <linux-kernel-owner+w=401wt.eu-S965457AbXAWV3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965457AbXAWV3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 16:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965260AbXAWV3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 16:29:49 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50882 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965156AbXAWV3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 16:29:48 -0500
Message-ID: <45B67E20.8020309@pobox.com>
Date: Tue, 23 Jan 2007 16:29:04 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Dale Farnsworth <dale@farnsworth.org>
CC: Thibaut VARENE <T-Bone@parisc-linux.org>, Jarek Poplawski <jarkao2@o2.pl>,
       mlachwani@mvista.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mv643xx_eth: Fix race condition in mv643xx_eth_free_tx_descs
References: <20070123165225.GA20153@xyzzy.farnsworth.org>
In-Reply-To: <20070123165225.GA20153@xyzzy.farnsworth.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dale Farnsworth wrote:
>>From Dale Farnsworth <dale@farnsworth.org>
> 
> mv643xx_eth: Fix race condition in mv643xx_eth_free_tx_descs
> 
> This bug was found and isolated by Thibaut VARENE <T-Bone@parisc-linux.org>
> and Jarek Poplawski <jarkao2@o2.pl>.  This patch is a modification of their
> fixes.  We acquire and release the lock for each descriptor that is freed
> to minimize the time the lock is held.
> 
> ---
> 
>  drivers/net/mv643xx_eth.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)

applied



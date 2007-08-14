Return-Path: <linux-kernel-owner+w=401wt.eu-S943297AbXHNFxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943297AbXHNFxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943125AbXHNFvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:51:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52094 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S943188AbXHNFvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:51:20 -0400
Message-ID: <46C142D5.6050800@garzik.org>
Date: Tue, 14 Aug 2007 01:51:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: NetDev <netdev@vger.kernel.org>, Keir Fraser <keir@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen-netfront: Avoid deref'ing skbafter it is potentially
 freed.
References: <46C0B6FD.7020701@goop.org>
In-Reply-To: <46C0B6FD.7020701@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> xennet_tx_bug_gc can free the skb before we use it, so make sure we don't.
> 
> Jeff, this is -rc material.
> 
> Signed-off-by: Keir Fraser <keir@xensource.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Jeff Garzik <jeff@garzik.org>

applied



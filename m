Return-Path: <linux-kernel-owner+w=401wt.eu-S937447AbXHGWZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937447AbXHGWZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760200AbXHGWZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:25:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48607 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757236AbXHGWZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:25:24 -0400
Message-ID: <46B8F149.3090706@garzik.org>
Date: Tue, 07 Aug 2007 18:25:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [PATCH] xen-netfront: remove dead code
References: <46B8EA9A.5020704@goop.org>
In-Reply-To: <46B8EA9A.5020704@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> This patch removes some residual dead code left over from removing the
> "flip" receive mode.  This patch doesn't change the generated output
> at all, since gcc already realized it was dead.
> 
> This resolves the "regression" reported by Adrian.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Adrian Bunk <bunk@stusta.de>
> Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> 
> ---
>  drivers/net/xen-netfront.c |   37 ++-----------------------------------
>  1 file changed, 2 insertions(+), 35 deletions(-)

Please send drivers/net/* through me and netdev...

	Jeff



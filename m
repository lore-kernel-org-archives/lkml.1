Return-Path: <linux-kernel-owner+w=401wt.eu-S1761215AbYBOSwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215AbYBOSwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760081AbYBOSwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:52:22 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54646 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759824AbYBOSwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:52:20 -0500
Message-ID: <47B5DF56.9040707@garzik.org>
Date: Fri, 15 Feb 2008 13:52:06 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Lord <mlord@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [libata-dev #upstream-fixes] pata_legacy: don't call ata_host_detach()
 after initialization failure
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <20080212081816.GA17820@elte.hu> <20080212071452.5c58ae6d@laptopd505.fenrus.org> <20080213090159.GA21614@elte.hu> <47B2B653.7020408@gmail.com>
In-Reply-To: <47B2B653.7020408@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> ata_host_detach() detaches an attached port and shouldn't be called on
> a port which hasn't been attached yet.  pata_legacy incorrectly calls
> ata_host_detach() on unattached port after initialization failure
> causing oops.  Fix it.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arjan van de Ven <arjan@infradead.org>
> ---
>  drivers/ata/pata_legacy.c |    2 --
>  1 file changed, 2 deletions(-)

applied



Return-Path: <linux-kernel-owner+w=401wt.eu-S1762209AbXIKBxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762209AbXIKBxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 21:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbXIKBxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 21:53:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43253 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628AbXIKBxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 21:53:15 -0400
Message-ID: <46E5F508.8000600@garzik.org>
Date: Mon, 10 Sep 2007 21:53:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jeff Norden <jeff@math.tntech.edu>
CC: alan@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] pata_it821x: fix lost interrupt with atapi devices
References: <200709041607.l84G7KsT032647@norden.math.tntech.edu>
In-Reply-To: <200709041607.l84G7KsT032647@norden.math.tntech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Norden wrote:
>  From: Jeff Norden <jnorden@math.tntech.edu>
> 
> Fix "lost" interrupt problem when using dma with CD/DVD drives in some
> configurations.  This problem can make installing linux from media
> impossible for distro's that have switched to libata-only configurations.
> 
> The simple fix is to eliminate the use of dma for reading drive status, etc,
> by checking the number of bytes to transferred.
> 
> This change will only affect the behavior of atapi devices, not disks.
> There is more info at http://bugzilla.redhat.com/show_bug.cgi?id=242229
> This patch is for 2.6.22.1
> 
> Signed-off-by: Jeff Norden <jnorden@math.tntech.edu>

applied



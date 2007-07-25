Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbXGYNtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbXGYNtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbXGYNtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:49:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37776 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbXGYNtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:49:04 -0400
Message-ID: <46A754C7.9080004@garzik.org>
Date: Wed, 25 Jul 2007 09:48:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Auke Kok <auke-jan.h.kok@intel.com>, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [-mm patch] one e1000 driver should be enough for everyone
References: <20070725040304.111550f4.akpm@linux-foundation.org> <20070725133650.GB3572@stusta.de>
In-Reply-To: <20070725133650.GB3572@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> BTW:
> Unless I'm misunderstanding anything, the new driver should support a 
> superset of what the old driver supported.
> Therefore, it would be good if the final merge into Linus' tree will
> do an
>   rm -r drivers/net/e1000
>   mv drivers/net/e1000new drivers/net/e1000

Based on the most recent discussion, e1000new (or whatever it will be 
called) should support only the newer PCI-Express chips, while e1000 
will retain support for the older chips.

Over the long term this will allow e1000new to grow without affecting 
support for the older, stable chips.

So, e1000 is not going away.

	Jeff



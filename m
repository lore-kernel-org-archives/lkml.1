Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZELAAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZELAAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbZEKX77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:59:59 -0400
Received: from outbound-mail-130.bluehost.com ([67.222.38.30]:34324 "HELO
	outbound-mail-130.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755102AbZEKX76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:59:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=gcMyugUFXN6AZdtnJXgEX0mfiTQnJcVBKxVWoH+eIyICqJToNDkA1xeetzmwW+f04aj0DY8MisFPrLH1e9xF6WJdvt032CI2N8Uqgm65XPcaqgT/sEFQlhAhjr+3b2ks;
Date: Mon, 11 May 2009 16:59:50 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Miller <davem@davemloft.net>
Cc: michael@ellerman.id.au, matthew@wil.cx, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix MSI-X with NIU cards
Message-ID: <20090511165950.0188ca5c@jbarnes-g45>
In-Reply-To: <20090511.164017.116664605.davem@davemloft.net>
References: <1242004911.7767.26.camel@concordia>
	<20090510.223645.193708481.davem@davemloft.net>
	<1242052211.7011.4.camel@concordia>
	<20090511.164017.116664605.davem@davemloft.net>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 16:40:17 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Michael Ellerman <michael@ellerman.id.au>
> Date: Tue, 12 May 2009 00:30:11 +1000
> 
> > On Sun, 2009-05-10 at 22:36 -0700, David Miller wrote:
> >> From: Michael Ellerman <michael@ellerman.id.au>
> >> Date: Mon, 11 May 2009 11:21:51 +1000
> >> 
> >> > So I guess this device is just silently ignoring that write?
> >> 
> >> No, it signals a fault on the PCI bus, which is how we noticed
> >> this problem in the first place.
> > 
> > But the patch doesn't change that? It just removes the readl AFAICS:
> 
> I'm on slow satellite internet here out in the ocean, so I wish
> the author of this patch would help with your feedback :-/
> 
> > Or has msix_mask_irq() changed since 413f81eba?
> 
> You could ask GIT, and to answer your question, indeed it has.
> 
> Please don't stall this patch very much, as the bug it is fixing konks
> out one of my primary test machines from even booting up.

Ok I'll stuff it into my for-linus queue now... Hopefully Matthew can
answer the question in the meantime.

-- 
Jesse Barnes, Intel Open Source Technology Center

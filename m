Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbZEKXkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbZEKXkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbZEKXkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:40:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42943
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142AbZEKXkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:40:20 -0400
Date: Mon, 11 May 2009 16:40:17 -0700 (PDT)
Message-Id: <20090511.164017.116664605.davem@davemloft.net>
To: michael@ellerman.id.au
Cc: matthew@wil.cx, jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix MSI-X with NIU cards
From: David Miller <davem@davemloft.net>
In-Reply-To: <1242052211.7011.4.camel@concordia>
References: <1242004911.7767.26.camel@concordia>
	<20090510.223645.193708481.davem@davemloft.net>
	<1242052211.7011.4.camel@concordia>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>
Date: Tue, 12 May 2009 00:30:11 +1000

> On Sun, 2009-05-10 at 22:36 -0700, David Miller wrote:
>> From: Michael Ellerman <michael@ellerman.id.au>
>> Date: Mon, 11 May 2009 11:21:51 +1000
>> 
>> > So I guess this device is just silently ignoring that write?
>> 
>> No, it signals a fault on the PCI bus, which is how we noticed
>> this problem in the first place.
> 
> But the patch doesn't change that? It just removes the readl AFAICS:

I'm on slow satellite internet here out in the ocean, so I wish
the author of this patch would help with your feedback :-/

> Or has msix_mask_irq() changed since 413f81eba?

You could ask GIT, and to answer your question, indeed it has.

Please don't stall this patch very much, as the bug it is fixing konks
out one of my primary test machines from even booting up.

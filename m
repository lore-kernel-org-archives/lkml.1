Return-Path: <linux-kernel-owner+w=401wt.eu-S936794AbXFGU4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936794AbXFGU4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763523AbXFGU4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:56:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53686 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118AbXFGU4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:56:37 -0400
Date: Thu, 7 Jun 2007 13:56:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
cc: Gregor Jasny <gjasny@googlemail.com>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
In-Reply-To: <4667B347.9040900@gmail.com>
Message-ID: <alpine.LFD.0.98.0706071352440.4205@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
  <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com> 
 <466196AD.3090502@garzik.org>  <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com>
  <46667466.4010500@gmail.com> <9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com>
 <4667B347.9040900@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jun 2007, Tejun Heo wrote:
>
> Ah.. okay.  Now I see what's going on.  Jeff, this is another device
> which doesn't set nsect and lbal to 1 after reset.  Gregor, please try
> the attached patch.

Tejun, since Jeff is apparently traveling this week, and Gregor tested the 
patch successfully (and it looks sane anyway - why in Gods name _would_ we 
care what the initial setting of nsect/lbal is?), can you send this in 
with the changelog and sign-off?

Maybe it can go through Andrew like the other patch (the sata_promise 
irq/polling handling), but I can take it directly too. Whatever seems 
best.

		Linus

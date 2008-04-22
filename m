Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbYDVXxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbYDVXxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYDVXxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:53:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753099AbYDVXxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:53:23 -0400
Date: Tue, 22 Apr 2008 16:52:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk
Subject: Re: [git patch] free_irq() fixes
In-Reply-To: <480E796E.4070001@garzik.org>
Message-ID: <alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>
References: <20080422221733.GA16260@havoc.gtf.org> <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org> <480E6DE5.6010103@garzik.org> <alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org> <480E796E.4070001@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Jeff Garzik wrote:
> [...]
> > Since the #irq-remove project involves removal of the 'irq' argument
> > from interrupt handlers (unused 99.8% of the time),
> [...]
> 
> After going over every irq handler (read: almost every driver in the kernel,
> plus arch code), my #irq-remove branch has confirmed what my gut already knew
> -- the 'irq' argument is completely unused for almost every driver.  So I was
> taking that line of thought as far as it went.

Ok, that's just not going to happen.

What's the upside? Really?

I can tell you the downsides:
 - tons of huge patches with ugly churn
 - total disaster when it comes to any drivers that are maintained over 
   multiple versions and/or out-of-tree like the DRI stuff

so those upsides had better be really big.

		Linus

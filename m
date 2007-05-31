Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbXEaPo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbXEaPo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXEaPoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:44:22 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:53995 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbXEaPoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:44:21 -0400
Date: Fri, 1 Jun 2007 00:43:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] sh updates for 2.6.22-rc4
Message-ID: <20070531154316.GA4392@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070531110037.GA4167@linux-sh.org> <465EB9FF.7090208@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465EB9FF.7090208@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 08:05:19AM -0400, Jeff Garzik wrote:
> Paul Mundt wrote:
> >Please pull from:
> >
> >	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git
> >
> >Which contains:
> 
> Out of curiosity, who maintains sh64?
> 
I do.

> It has a couple irq handlers that have not been updated since the Oct 
> 2006 update that changed every irq handler in the kernel:
> 
> arch/sh64/kernel/dma.c:static irqreturn_t dma_mte(int irq, void *dev_id, 
> struct pt_regs *regs)
> arch/sh64/kernel/dma.c:static irqreturn_t dma_err(int irq, void *dev_id, 
> struct pt_regs *regs)
> 
Ah, yes, that isn't included in the defconfig I use, so I missed it. I'll
fix it up with the next batch.

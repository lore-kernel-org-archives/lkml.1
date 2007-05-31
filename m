Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbXEaMFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbXEaMFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759590AbXEaMF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:05:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42651 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759409AbXEaMF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:05:28 -0400
Message-ID: <465EB9FF.7090208@garzik.org>
Date: Thu, 31 May 2007 08:05:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] sh updates for 2.6.22-rc4
References: <20070531110037.GA4167@linux-sh.org>
In-Reply-To: <20070531110037.GA4167@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> Please pull from:
> 
> 	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git
> 
> Which contains:

Out of curiosity, who maintains sh64?

It has a couple irq handlers that have not been updated since the Oct 
2006 update that changed every irq handler in the kernel:

arch/sh64/kernel/dma.c:static irqreturn_t dma_mte(int irq, void *dev_id, 
struct pt_regs *regs)
arch/sh64/kernel/dma.c:static irqreturn_t dma_err(int irq, void *dev_id, 
struct pt_regs *regs)

Regards,

	Jeff



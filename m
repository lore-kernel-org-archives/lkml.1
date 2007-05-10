Return-Path: <linux-kernel-owner+w=401wt.eu-S1762073AbXEJW1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762073AbXEJW1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbXEJW1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:27:03 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755829AbXEJW1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:27:01 -0400
Date: Thu, 10 May 2007 15:26:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: andrew@sanpeople.com, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCHv2] at91: fix enable/disable_irq_wake symmetry in pcmcia
 driver
Message-Id: <20070510152636.4adb3ef1.akpm@linux-foundation.org>
In-Reply-To: <200705101009.36302.marc.pignat@hevs.ch>
References: <200705101009.36302.marc.pignat@hevs.ch>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 10:09:35 +0200
Marc Pignat <marc.pignat@hevs.ch> wrote:

> from Marc Pignat <marc.pignat@hevs.ch>
> 
> fix enable_irq_wake and disable_irq_wake symmetry in at91 pcmcia driver
> 
> Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
> ---
> Please forget the [PATCH] at91: fix enable/disable_irq_wake symmetry in pcmcia driver,
> it doesn't compile... Here is the good patch!
> 
> This patch applies to the 2.6.21.1 kernel.
> 
> disable_irq_wake call must be symmetric with enable_irq_wake. This patch fix 
> that problem for the at91_pcmia driver.
> It seems that this patch was forgotten when we've fixed irq_wake symmetry in 
> all at91 related drivers.
> It was discussed in the "at91 drivers and [enable/disable]_irq_wake (wrong?) 
> usage" thread on the linux-arm-kernel mailing list.


That's not a terribly useful changelog, sorry.  I look at the patch and I
don't know what was wrong with the old code, nor how this new code improves
things.

"disable_irq_wake call must be symmetric with enable_irq_wake".  hmm, OK,
I'll take your word for it.

Does the present code actually fail in some manner, or what?

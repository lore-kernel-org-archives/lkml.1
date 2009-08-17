Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZHQUmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZHQUmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZHQUml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:42:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbZHQUmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:42:40 -0400
Date: Mon, 17 Aug 2009 13:42:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] irq fixes for 2.6.31
In-Reply-To: <alpine.LFD.2.00.0908172055360.2782@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908171340540.3162@localhost.localdomain>
References: <alpine.LFD.2.00.0908172055360.2782@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Aug 2009, Thomas Gleixner wrote:
> 
> Please pull the latest irq-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus
> 
> Thanks,
> 
> 	tglx
> 
> ------------------>
> Thomas Gleixner (1):
>       genirq: Do not wakeup irq thread from __setup_irq() and set action->irq
> 
> 
>  kernel/irq/manage.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

This is not what I get when I pull. Instead I get the "genirq: Prevent 
race between free_irq() and handle_IRQ_event()" commit that I thought we 
agreed wasn't correct.

		Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S2992538AbXCWTCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992538AbXCWTCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbXCWTBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:01:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:32792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbXCWTB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:01:27 -0400
Message-Id: <20070323164447.659982000@strauss.suse.de>
User-Agent: quilt/0.46-14
Date: Fri, 23 Mar 2007 17:44:47 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 0/7] Add IRQF_IRQPOLL_IRQ flag to allow irqpoll
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

irqpoll is broken on some architectures that don't use the IRQ 0 for the timer
interrupt like IA64. This patch adds a IRQF_IRQPOLL_IRQ flag.

Each architecture is handled in a separate pach. As I left the irq == 0 as
condition, this should not break existing architectures that use timer_irq == 0
and that I did't address with that patch (because I don't know).


Signed-off-by: Bernhard Walle <bwalle@suse.de>

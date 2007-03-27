Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbXC0Ur3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbXC0Ur3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbXC0Ur3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:47:29 -0400
Received: from ns1.suse.de ([195.135.220.2]:51927 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbXC0Ur3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:47:29 -0400
Message-Id: <20070327202234.639415000@strauss.suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 27 Mar 2007 22:22:34 +0200
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/7] Add IRQF_IRQPOLL flag to allow irqpoll
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

irqpoll is broken on some architectures that don't use the IRQ 0 for the timer
interrupt like IA64. This patch adds a IRQF_IRQPOLL flag.

Each architecture is handled in a separate pach. As I left the irq == 0 as
condition, this should not break existing architectures that use timer_irq == 0
and that I did't address with that patch (because I don't know).


Signed-off-by: Bernhard Walle <bwalle@suse.de>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZKQWwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZKQWwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbZKQWwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:52:00 -0500
Received: from www.tglx.de ([62.245.132.106]:41621 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668AbZKQWv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:51:58 -0500
Message-Id: <20091117224852.846805939@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 17 Nov 2009 22:50:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [patch 00/13] Remove the last leftover of the irq_chip migration:
	irq_chip.typename
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chip->typename is the last migration helper leftover of the
conversion from hw_irqcontroller to irq_chip.

Fixup the remaining users and kill the extra pointer in struct irq_chip.

Thanks,

	tglx




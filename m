Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbYGQMQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbYGQMQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 08:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756706AbYGQMQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 08:16:09 -0400
Received: from khc.piap.pl ([195.187.100.11]:38061 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794AbYGQMQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 08:16:06 -0400
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Vrabel <david.vrabel@csr.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PCI: MSI interrupts masked using prohibited method
References: <4860D09D.4060801@csr.com> <4864DA54.6000205@csr.com>
	<200806271007.26248.jbarnes@virtuousgeek.org>
	<200807161243.03360.jbarnes@virtuousgeek.org>
	<20080716195853.GL25255@parisc-linux.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 17 Jul 2008 14:16:03 +0200
In-Reply-To: <20080716195853.GL25255@parisc-linux.org> (Matthew Wilcox's message of "Wed\, 16 Jul 2008 13\:58\:53 -0600")
Message-ID: <m3wsjkemf0.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> writes:

> For these devices, we call
>                         msi_set_enable(entry->dev, !flag);
>
> which turns off the PCI_MSI_FLAGS_ENABLE bit.  I'm not sure I see the
> bit in the PCI spec that says devices are then allowed to ignore the
> Interrupt Disable bit in the device control register, but I concede such
> devices may be out there.

Remember that MSI predates INTX disable bit.
-- 
Krzysztof Halasa

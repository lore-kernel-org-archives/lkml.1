Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbXJ3XCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbXJ3XCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXJ3XCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:02:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49397
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbXJ3XCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:02:37 -0400
Date: Tue, 30 Oct 2007 16:02:21 -0700 (PDT)
Message-Id: <20071030.160221.27099706.davem@davemloft.net>
To: rdreier@cisco.com
Cc: jeff@garzik.org, shawnxjin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Multiple MSI messages support
From: David Miller <davem@davemloft.net>
In-Reply-To: <adaejfci5cz.fsf@cisco.com>
References: <c3d0340b0710301413r2607ee08x8b27c5bffa43f1c4@mail.gmail.com>
	<4727AED2.6010908@garzik.org>
	<adaejfci5cz.fsf@cisco.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 30 Oct 2007 15:51:08 -0700

> In fact at least IBM pSeries boxes seem to be able to use MSI to
> generate multiple interrupts from the same device -- BenH can probably
> give details.

Sparc64 PCI-E controllers can do this as well.

> For high-performance devices this is not really true.  The InfiniBand
> mthca driver can use MSI to get a single interrupt, or MSI-X to get
> different interrupts for different types of events.  MSI-X allows the
> read of the "interrupt cause register" to be avoided, and this ends up
> making a measurable performance difference for the fast path.
> 
> Also, obviously, having multiple interrupts means you can bind
> different interrupts to different CPUs, which will become very
> important if/when things like multi-queue NICs are supported.

Right, and this is used heavily in the NIU driver for example.

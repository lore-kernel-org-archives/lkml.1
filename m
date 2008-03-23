Return-Path: <linux-kernel-owner+w=401wt.eu-S1759914AbYCWKKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914AbYCWKKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 06:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759482AbYCWKKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 06:10:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45927
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759422AbYCWKKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 06:10:22 -0400
Date: Sun, 23 Mar 2008 03:10:36 -0700 (PDT)
Message-Id: <20080323.031036.09404846.davem@davemloft.net>
To: khaled.linux@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: spinlock BUG in qdisc_restart
From: David Miller <davem@davemloft.net>
In-Reply-To: <89cb5ede0803230023h49563614h57cad4a25d7753a4@mail.gmail.com>
References: <89cb5ede0803230023h49563614h57cad4a25d7753a4@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Khaled Al-Hamwi" <khaled.linux@gmail.com>
Date: Sun, 23 Mar 2008 10:23:20 +0300

> [<c02845af>] netif_receive_skb+0x1fc/0x23e
> [<e033b560>] MM_IndicateRxPackets+0x2be/0x379 [bcm5700]
> [<e0342c26>] LM_ServiceInterrupts+0xac/0xc5 [bcm5700]
> [<e0337768>] bcm5700_interrupt+0x13c/0x2bd [bcm5700]

This backtrace is not from a driver that is in the upstream kernel
sources.

Please use the supported and upstream "tg3" driver for this hardware.

Thank you.

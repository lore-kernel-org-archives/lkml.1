Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYCMJbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYCMJbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 05:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYCMJbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 05:31:06 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34882 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbYCMJbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 05:31:05 -0400
Date: Thu, 13 Mar 2008 10:31:02 +0100
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Zhang Wei <wei.zhang@freescale.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsldma: Add a completed cookie updated action in DMA
	finish interrupt.
Message-ID: <20080313093102.GB17404@Chamillionaire.breakpoint.cc>
References: <1205391260-4482-1-git-send-email-wei.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1205391260-4482-1-git-send-email-wei.zhang@freescale.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zhang Wei | 2008-03-13 14:54:20 [+0800]:

>The patch 'fsldma: do not cleanup descriptors in hardirq context'
>(commit 222ccf9ab838a1ca7163969fabd2cddc10403fb5) removed descriptors
>cleanup function to tasklet but the completed cookie do not updated.
>Thus, the DMA controller will get lots of duplicated transfer
>interrupts. Just make a completed cookie update in interrupt handler.
>And keep other cleanup jobs in tasklet function.
>
>Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Tested-by: Sebastian Siewior <bigeasy@linutronix.de>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbYJXXSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbYJXXSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYJXXSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:18:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55479
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbYJXXSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:18:36 -0400
Date: Fri, 24 Oct 2008 16:18:13 -0700 (PDT)
Message-Id: <20081024.161813.193686281.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       maxk@qualcomm.com, akpm@osdl.org, tglx@linutronix.de
Subject: Re: [PATCH] genirq: Set initial default irq affinity to just CPU0
From: David Miller <davem@davemloft.net>
In-Reply-To: <1224863858-7933-1-git-send-email-galak@kernel.crashing.org>
References: <1224863858-7933-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Fri, 24 Oct 2008 10:57:38 -0500

> Commit 18404756765c713a0be4eb1082920c04822ce588 introduced a regression
> on a subset of SMP based PPC systems whose interrupt controller only
> allow setting an irq to a single processor.  The previous behavior
> was only CPU0 was initially setup to get interrupts.  Revert back
> to that behavior.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

I really don't remember getting all of my interrupts only on cpu 0
on sparc64 before any of these changes.  I therefore find all of
this quite mysterious. :-)

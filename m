Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbXI1IRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbXI1IRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXI1IRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:17:36 -0400
Received: from www.osadl.org ([213.239.205.134]:59436 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753179AbXI1IRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:17:34 -0400
Subject: Re: [PATCH] spin_lock_unlocked cleanups
From: Thomas Gleixner <tglx@linutronix.de>
To: roel <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <46FC2245.50907@tiscali.nl>
References: <46FC2245.50907@tiscali.nl>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 10:17:30 +0200
Message-Id: <1190967450.18681.10.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-27 at 23:36 +0200, roel wrote:
> Replace some SPIN_LOCK_UNLOCKED with DEFINE_SPINLOCK
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

Andy, Randy,

can we please add this to checkpatch.pl ? 

> -spinlock_t bpci_lock = SPIN_LOCK_UNLOCKED;
> +DEFINE_SPINLOCK(bpci_lock);

This code was introduced in June 2007, almost two years after the first
big DEFINE_SPINLOCK cleanup. Sigh.

Thanks,

	tglx





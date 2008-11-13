Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYKMWXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYKMWXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYKMWXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:23:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39108
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751697AbYKMWXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:23:44 -0500
Date: Thu, 13 Nov 2008 14:23:43 -0800 (PST)
Message-Id: <20081113.142343.225648934.davem@davemloft.net>
To: paulus@samba.org
Cc: akpm@linux-foundation.org, yinghai@kernel.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       travis@sgi.com
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
From: David Miller <davem@davemloft.net>
In-Reply-To: <18716.42977.127816.205211@cargo.ozlabs.ibm.com>
References: <491C8B38.9060901@kernel.org>
	<20081113131850.d94fb229.akpm@linux-foundation.org>
	<18716.42977.127816.205211@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Fri, 14 Nov 2008 09:19:13 +1100

> Andrew Morton writes:
> 
> > Other architectures want (or have) sparse interrupts.  Are those guys
> > paying attention here?
> 
> On powerpc we have a mapping from virtual irq numbers (in the range 0
> to NR_IRQS-1) to physical irq numbers (which can be anything) and back
> again.  I think our approach is simpler than what's being proposed
> here, though we don't try to keep the irqdescs node-local as this
> patch seems to (fortunately our big systems aren't so NUMA-ish as to
> make that necessary).

This is exactly what sparc64 does as well, same as powerpc, and
as Paul said it's so much incredibly simpler than the dyn_irq stuff.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYKNAWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYKNAWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYKNAVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:21:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57911
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756293AbYKNAVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:21:52 -0500
Date: Thu, 13 Nov 2008 16:21:44 -0800 (PST)
Message-Id: <20081113.162144.155677034.davem@davemloft.net>
To: travis@sgi.com
Cc: paulus@samba.org, akpm@linux-foundation.org, yinghai@kernel.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
From: David Miller <davem@davemloft.net>
In-Reply-To: <491CC310.3050807@sgi.com>
References: <491CB421.2020701@sgi.com>
	<20081113.151435.146617325.davem@davemloft.net>
	<491CC310.3050807@sgi.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Travis <travis@sgi.com>
Date: Thu, 13 Nov 2008 16:15:12 -0800

> David Miller wrote:
> > From: Mike Travis <travis@sgi.com>
> > Date: Thu, 13 Nov 2008 15:11:29 -0800
> > 
> > We use a value of 256 and I've been booting linux on 128 cpu sparc64
> > systems with lots of PCI-E host controllers (and others have booted it
> > on even larger ones).  All of which have several NUMA domains.
> > 
> > It's not an issue.
> 
> Are you saying that having a fixed count of IRQ's is not an issue?  With
> NR_CPUS=4096 what would you fix it to?  (Currently it's NR_CPUS * 32
> but that might not be sufficient.)  Would NR_CPUS=16384 make it an issue?

Nope, and nope.  I frequently run kernels with NR_CPUS set to huge
values.

It seems that the issue of x86 is that it has it's IRQ count tied to
the number of cpus, that's not very intelligent.  Perhaps that part
should be rearranged somehow?

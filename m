Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbXI2FmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbXI2FmF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 01:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbXI2Flw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 01:41:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbXI2Flv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 01:41:51 -0400
Date: Fri, 28 Sep 2007 22:40:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andy Fleming <afleming@freescale.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PHYLIB: Spinlock fixes for softirqs
Message-Id: <20070928224055.4415e47e.akpm@linux-foundation.org>
In-Reply-To: <46FDE348.3010801@pobox.com>
References: <Pine.LNX.4.64N.0709181532190.9650@blysk.ds.pg.gda.pl>
	<46FDE348.3010801@pobox.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007 01:31:52 -0400 Jeff Garzik <jgarzik@pobox.com> wrote:

> doesn't Andrew have a version of these patches that move the useful 
> patch text into the area where it will get copied into the permanent 
> kernel changelog?
> 
> also, your PHYLIB patches give no notion at all of proper patch order.
> 

Andrew has patches coming out of his ears.  umm....

Applying order:

phylib-spinlock-fixes-for-softirqs.patch
phylib-irq-event-workqueue-handling-fixes.patch
phylib-fix-an-interrupt-loop-potential-when-halting.patch

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/broken-out/phylib-spinlock-fixes-for-softirqs.patch
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/broken-out/phylib-irq-event-workqueue-handling-fixes.patch
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/broken-out/phylib-fix-an-interrupt-loop-potential-when-halting.patch

Let me unload some netdev patches at you...

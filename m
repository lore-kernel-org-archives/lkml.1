Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbXEAXFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbXEAXFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbXEAXFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:05:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44869 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754796AbXEAXF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:05:29 -0400
Date: Wed, 2 May 2007 00:07:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bill Irwin <bill.irwin@oracle.com>
Cc: Matt Mackall <mpm@selenic.com>, Christoph Hellwig <hch@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, wli@holomorphy.com
Subject: Re: [2/6] add config option to vmalloc stacks (was: Re: [-mm patch]
 i386: enable 4k stacks by default)
Message-ID: <20070502000745.3a819160@the-village.bc.nu>
In-Reply-To: <20070501225125.GU26598@holomorphy.com>
References: <20070430091754.24df88df@the-village.bc.nu>
	<p73wszuyx7h.fsf@bingen.suse.de>
	<20070430104806.GA14944@infradead.org>
	<p73slaiys9v.fsf@bingen.suse.de>
	<20070430173819.GC19966@holomorphy.com>
	<20070430174310.GE19966@holomorphy.com>
	<20070430181104.GB14739@infradead.org>
	<20070430190952.GP31925@holomorphy.com>
	<20070430191511.GA25318@infradead.org>
	<20070501223606.GQ11166@waste.org>
	<20070501225125.GU26598@holomorphy.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> These IRQ stacks are per-cpu, not per-IRQ. It may make sense to
> implement per-IRQ stacks, in which case dynamic allocation at the time
> of request_irq() will make sense.

This depends if active IRQ count exceeds active CPU count worst cases.
For the big boxes it might well do but for small ones we seem to be best
with per CPU.

Alan

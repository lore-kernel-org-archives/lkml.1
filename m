Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbXEAWzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbXEAWzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbXEAWzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:55:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61209 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbXEAWzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:55:08 -0400
Date: Tue, 1 May 2007 15:51:25 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, wli@holomorphy.com
Subject: Re: [2/6] add config option to vmalloc stacks (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070501225125.GU26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Matt Mackall <mpm@selenic.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <andi@firstfloor.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
	Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174310.GE19966@holomorphy.com> <20070430181104.GB14739@infradead.org> <20070430190952.GP31925@holomorphy.com> <20070430191511.GA25318@infradead.org> <20070501223606.GQ11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501223606.GQ11166@waste.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 08:15:11PM +0100, Christoph Hellwig wrote:
>> So if you want to invest some time into getting this into mergeable
>> shape I'd suggest you redo the patch series in the following way:
>>  patch 1: dynamic allocated irq stacks

On Tue, May 01, 2007 at 05:36:06PM -0500, Matt Mackall wrote:
> Can we register them lazily at request_irq time?

These IRQ stacks are per-cpu, not per-IRQ. It may make sense to
implement per-IRQ stacks, in which case dynamic allocation at the time
of request_irq() will make sense.

Would you like me to implement per-IRQ IRQ stacks?


-- wli

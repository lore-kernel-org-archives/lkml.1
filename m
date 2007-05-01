Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbXEAXXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbXEAXXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbXEAXXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:23:34 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15191 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbXEAXXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:23:33 -0400
Date: Tue, 1 May 2007 16:23:01 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bill Irwin <bill.irwin@oracle.com>, Matt Mackall <mpm@selenic.com>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, wli@holomorphy.com
Subject: Re: [2/6] add config option to vmalloc stacks (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070501232301.GW26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Mackall <mpm@selenic.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <andi@firstfloor.org>, David Chinner <dgc@sgi.com>,
	Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174310.GE19966@holomorphy.com> <20070430181104.GB14739@infradead.org> <20070430190952.GP31925@holomorphy.com> <20070430191511.GA25318@infradead.org> <20070501223606.GQ11166@waste.org> <20070501225125.GU26598@holomorphy.com> <20070502000745.3a819160@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502000745.3a819160@the-village.bc.nu>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At some point in the past, I wrote:
>> These IRQ stacks are per-cpu, not per-IRQ. It may make sense to
>> implement per-IRQ stacks, in which case dynamic allocation at the time
>> of request_irq() will make sense.

On Wed, May 02, 2007 at 12:07:45AM +0100, Alan Cox wrote:
> This depends if active IRQ count exceeds active CPU count worst cases.
> For the big boxes it might well do but for small ones we seem to be best
> with per CPU.

I'll leave IRQ stacks per-CPU, then. The prevailing opinion on large
i386 does not favor doing much of anything to accommodate it.


-- wli

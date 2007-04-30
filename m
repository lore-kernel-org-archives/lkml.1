Return-Path: <linux-kernel-owner+w=401wt.eu-S1946553AbXD3SP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946553AbXD3SP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946554AbXD3SP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:15:59 -0400
Received: from holomorphy.com ([66.93.40.71]:56675 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946553AbXD3SP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:15:58 -0400
Date: Mon, 30 Apr 2007 11:13:15 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [1/6] make stack size configurable (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430181315.GJ19966@holomorphy.com>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174047.GD19966@holomorphy.com> <20070430181032.GA14739@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430181032.GA14739@infradead.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:40:47AM -0700, William Lee Irwin III wrote:
>> Make more stack sizes configurable, adding options for deeper stacks.
>> This is largely for differential diagnosis in cases where stack overflows
>> are suspected of silently corrupting memory or causing other problems not
>> detected immediately.

On Mon, Apr 30, 2007 at 07:10:32PM +0100, Christoph Hellwig wrote:
> I don't think we want anything bigger than 8, if you really need that
> for debuggin it's easy enough to hack up on demand.

These were instrumentation patches of such a form. The point of all
this was mostly centered around 5/6, which bootmem allocates the
various IRQ stacks as mentioned earlier.


- wli

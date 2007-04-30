Return-Path: <linux-kernel-owner+w=401wt.eu-S1946707AbXD3T1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946707AbXD3T1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946717AbXD3T1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:27:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:60409 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946707AbXD3T1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:27:09 -0400
Date: Mon, 30 Apr 2007 12:23:31 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2/6] add config option to vmalloc stacks (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430192331.GC26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <andi@firstfloor.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
	Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174310.GE19966@holomorphy.com> <20070430181104.GB14739@infradead.org> <20070430190952.GP31925@holomorphy.com> <20070430191511.GA25318@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430191511.GA25318@infradead.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 08:15:11PM +0100, Christoph Hellwig wrote:
> So if you want to invest some time into getting this into mergeable
> shape I'd suggest you redo the patch series in the following way:
>  patch 1: dynamic allocated irq stacks
>  patch 2: make irqstacks unconditional, but allow selecting 4/8k stacks
>  patch 3: introduce a DEBUG_STACK option that enables vmalloc'ed stacks
>  	  and adds the __pa check.

This was actually done for work purposes, hence the change of email
addresses.

I can redo it in such a manner, provided it's not duplicating mergework
Andi Kleen intends to do or otherwise includes pieces (like the __pa()
check) he'd prefer to drop.


-- wli

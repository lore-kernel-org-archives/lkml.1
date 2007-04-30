Return-Path: <linux-kernel-owner+w=401wt.eu-S1423702AbXD3TBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423702AbXD3TBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423692AbXD3TA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:00:58 -0400
Received: from holomorphy.com ([66.93.40.71]:48470 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946632AbXD3TAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:00:42 -0400
Date: Mon, 30 Apr 2007 11:58:01 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [4/6] go BUG on vmallocspace in __pa() (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430185801.GN19966@holomorphy.com>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174510.GG19966@holomorphy.com> <20070430185242.GB11512@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430185242.GB11512@one.firstfloor.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:38:19AM -0700, William Lee Irwin III wrote:
>>> Here's what I did for i386 for someone concerned about blowing the stack.

On Mon, Apr 30, 2007 at 10:45:10AM -0700, William Lee Irwin III wrote:
>> Add checks to __pa() so it goes BUG() on vmallocspace addresses.

On Mon, Apr 30, 2007 at 08:52:42PM +0200, Andi Kleen wrote:
> Sorry I think that's too costly to do. __pa is pretty common

The original intention essentially ignored efficiency. I've no
objection to dropping whatever pieces don't fit (or, for that matter,
whatever sort of NIH). The hope in posting all this was that some piece
might be found useful as an example or guide to doing the real patches
for mainline. If any of it is useful as it stands, that's good too.


-- wli

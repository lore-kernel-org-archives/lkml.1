Return-Path: <linux-kernel-owner+w=401wt.eu-S1423570AbXD3SiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423570AbXD3SiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423628AbXD3SiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:38:15 -0400
Received: from holomorphy.com ([66.93.40.71]:54966 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423570AbXD3SiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:38:13 -0400
Date: Mon, 30 Apr 2007 11:35:29 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [-mm patch] i386: enable 4k stacks by default
Message-ID: <20070430183529.GM19966@holomorphy.com>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <Pine.LNX.4.61.0704302021160.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704302021160.29151@yvahk01.tjqt.qr>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 30 2007 10:38, William Lee Irwin III wrote:
>> Here's what I did for i386 for someone concerned about blowing the stack.

On Mon, Apr 30, 2007 at 08:22:43PM +0200, Jan Engelhardt wrote:
> If we really need it, then maybe a variable like CONFIG_LOG_BUF_SHIFT
> could be hacked up, resulting in CONFIG_THREAD_SIZE_SHIFT, defaulting to 3
> (=8KB).

I wouldn't bother with that. This is all just a sample of apparently
working code that bootmem allocates IRQ stacks.

It's a set of debug patches so there's no intention of any of this
being merged as-posted.


-- wli

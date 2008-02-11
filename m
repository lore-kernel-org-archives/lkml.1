Return-Path: <linux-kernel-owner+w=401wt.eu-S1757705AbYBKQQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbYBKQQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbYBKQPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:15:54 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:56571 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbYBKQPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:15:53 -0500
Date: Mon, 11 Feb 2008 09:15:50 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Camuso <tcamuso@redhat.com>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: raw_pci_read in quirk_intel_irqbalance
Message-ID: <20080211161550.GL5299@parisc-linux.org>
References: <20080209124138.GA28967@parisc-linux.org> <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com> <20080210072116.GA12375@kroah.com> <20080210145122.GC5299@parisc-linux.org> <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com> <alpine.LFD.1.00.0802101222560.2896@woody.linux-foundation.org> <20080210204556.GG5299@parisc-linux.org> <20080210230204.GH5299@parisc-linux.org> <20080211050415.GJ5299@parisc-linux.org> <20080211074954.GA11388@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211074954.GA11388@colo.lackof.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 12:49:54AM -0700, Grant Grundler wrote:
> Can you also add a comment which points at the Intel documentation?
> 
> http://download.intel.com/design/chipsets/datashts/30300702.pdf
> Page 34 documents 0xf4 register.

I'm told that these URLs are not guaranteed to be stable.  And
remembering the pain we had when HP decided to relocate all of their
documents, I'm really not inclined to embed a link to a URL in the
source code.

> And I just doubled checked that the 0xf4 register value is restored later
> in the quirk (obvious when you look at the code but not from the patch).

Yep, I checked that too ;-)

> Acked-by: Grant Grundler <grundler@parisc-linux.org>

Thanks.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

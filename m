Return-Path: <linux-kernel-owner+w=401wt.eu-S1946623AbXD3Swp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946623AbXD3Swp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946630AbXD3Swp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:52:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47955 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946623AbXD3Swn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:52:43 -0400
Date: Mon, 30 Apr 2007 20:52:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [4/6] go BUG on vmallocspace in __pa() (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430185242.GB11512@one.firstfloor.org>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174510.GG19966@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430174510.GG19966@holomorphy.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:45:10AM -0700, William Lee Irwin III wrote:
> On Mon, Apr 30, 2007 at 10:38:19AM -0700, William Lee Irwin III wrote:
> > Here's what I did for i386 for someone concerned about blowing the stack.
> 
> Add checks to __pa() so it goes BUG() on vmallocspace addresses.

Sorry I think that's too costly to do. __pa is pretty common

-Andi

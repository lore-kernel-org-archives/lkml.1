Return-Path: <linux-kernel-owner+w=401wt.eu-S1423440AbXD3SK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423440AbXD3SK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423511AbXD3SK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:10:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54663 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946549AbXD3SKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:10:40 -0400
Date: Mon, 30 Apr 2007 19:10:32 +0100
From: Christoph Hellwig <hch@infradead.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [1/6] make stack size configurable (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430181032.GA14739@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	William Lee Irwin III <wli@holomorphy.com>,
	Andi Kleen <andi@firstfloor.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
	Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174047.GD19966@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430174047.GD19966@holomorphy.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:40:47AM -0700, William Lee Irwin III wrote:
> On Mon, Apr 30, 2007 at 10:38:19AM -0700, William Lee Irwin III wrote:
> > Here's what I did for i386 for someone concerned about blowing the stack.
> 
> Make more stack sizes configurable, adding options for deeper stacks.
> This is largely for differential diagnosis in cases where stack overflows
> are suspected of silently corrupting memory or causing other problems not
> detected immediately.

I don't think we want anything bigger than 8, if you really need that
for debuggin it's easy enough to hack up on demand.


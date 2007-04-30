Return-Path: <linux-kernel-owner+w=401wt.eu-S1946677AbXD3TP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946677AbXD3TP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 15:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946675AbXD3TP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 15:15:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35836 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946700AbXD3TPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 15:15:17 -0400
Date: Mon, 30 Apr 2007 20:15:11 +0100
From: Christoph Hellwig <hch@infradead.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2/6] add config option to vmalloc stacks (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430191511.GA25318@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	William Lee Irwin III <wli@holomorphy.com>,
	Andi Kleen <andi@firstfloor.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
	Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174310.GE19966@holomorphy.com> <20070430181104.GB14739@infradead.org> <20070430190952.GP31925@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430190952.GP31925@holomorphy.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So if you want to invest some time into getting this into mergeable
shape I'd suggest you redo the patch series in the following way:

 patch 1: dynamic allocated irq stacks
 patch 2: make irqstacks unconditional, but allow selecting 4/8k stacks
 patch 3: introduce a DEBUG_STACK option that enables vmalloc'ed stacks
 	  and adds the __pa check.

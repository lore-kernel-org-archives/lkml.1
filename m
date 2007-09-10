Return-Path: <linux-kernel-owner+w=401wt.eu-S933421AbXIJMTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421AbXIJMTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbXIJMTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:19:36 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:38564
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756952AbXIJMTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:19:36 -0400
Date: Mon, 10 Sep 2007 05:18:38 -0700 (PDT)
Message-Id: <20070910.051838.41660444.davem@davemloft.net>
To: hch@infradead.org
Cc: bunk@kernel.org, akpm@linux-foundation.org, perex@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070909203920.GA11764@infradead.org>
References: <20070909202527.GT3563@stusta.de>
	<20070909203920.GA11764@infradead.org>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 9 Sep 2007 21:39:20 +0100

> On Sun, Sep 09, 2007 at 10:25:28PM +0200, Adrian Bunk wrote:
> > sys_{open,read} can finally be unexported.
> 
> Andrew, can you please put this in?  Having these exports for syscalls around
> hsa been a long-time annoyance that can finally be fixed now.

I'm happy to see this go too, but please add the necessary
export to arch/sparc64/kernel/sparc64_ksyms.S so that the
solaris system call table reference in
arch/sparc64/solaris/systbls.S can be satisfied.

This keeps coming up, and people keep missing the reference
in the solaris compatibility module.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1423205AbXD3Mmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423205AbXD3Mmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 08:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423211AbXD3Mml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 08:42:41 -0400
Received: from ns.suse.de ([195.135.220.2]:33062 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423205AbXD3Mmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 08:42:40 -0400
Date: Mon, 30 Apr 2007 15:40:01 +0200
From: Andi Kleen <ak@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <ak@suse.de>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Christoph Hellwig <hch@infradead.org>, mingo@elte.hu,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [39/40] i386: Export paravirt_ops for non GPL modules too
Message-ID: <20070430134001.GC25929@bingen.suse.de>
References: <200704301227.598020000@suse.de> <200704301300.31298.ak@suse.de> <Pine.LNX.4.61.0704301315080.29151@yvahk01.tjqt.qr> <200704301319.54291.ak@suse.de> <1177936139.4843.17.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177936139.4843.17.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> FWIW I think doing this first will be better, exposing _all_ to non GNU
> modules will weaken whatever case we might have to take it away later.

I have no problems taking it away later again. Or rather taking
away the symbols where non GPL code clearly has no business messing
with.

I don't think that applies to save_fl/restore_fl/irq_disable/irq_enable 
though. Undecided yet about the page table manipulation code (set_pte etc.)


-Andi

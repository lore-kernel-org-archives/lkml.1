Return-Path: <linux-kernel-owner+w=401wt.eu-S1030631AbXFHPff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030631AbXFHPff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967186AbXFHPfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:35:17 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57422 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965133AbXFHPfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:35:14 -0400
Date: Fri, 8 Jun 2007 11:35:13 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
Message-ID: <20070608153513.GE25649@havoc.gtf.org>
References: <466196AD.3090502@garzik.org> <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com> <46667466.4010500@gmail.com> <9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com> <4667B347.9040900@gmail.com> <alpine.LFD.0.98.0706071352440.4205@woody.linux-foundation.org> <20070607224746.GA23290@havoc.gtf.org> <46690D10.9040808@gmail.com> <20070608143136.GC25649@havoc.gtf.org> <20070608163804.4926e499@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608163804.4926e499@the-village.bc.nu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 04:38:04PM +0100, Alan Cox wrote:
> > See a URL I posted earlier in this thread.  With dumb ATAPI devices we
> > actually have to wait a bit for BSY to be asserted.  Not only at reset,
> > but also for every command
> 
> 400nS and the current code correctly accounts for it.

No, _far_ longer than 400nS.  2ms minimum by the spec, but,

ATADRVR. blackmagic.html and googling around shows plenty of ATAPI
devices that don't get their shit together for 50-100ms.

The BIOS source I'm reviewing right now waits 50ms, after SRST.

	Jeff




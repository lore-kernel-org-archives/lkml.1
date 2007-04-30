Return-Path: <linux-kernel-owner+w=401wt.eu-S1423202AbXD3Mcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423202AbXD3Mcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 08:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423200AbXD3Mcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 08:32:42 -0400
Received: from amsfep20-int.chello.nl ([62.179.120.15]:44755 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423202AbXD3Mcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 08:32:41 -0400
Subject: Re: [PATCH] [39/40] i386: Export paravirt_ops for non GPL modules
	too
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@suse.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Christoph Hellwig <hch@infradead.org>, mingo@elte.hu,
       patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <200704301319.54291.ak@suse.de>
References: <200704301227.598020000@suse.de> <200704301300.31298.ak@suse.de>
	 <Pine.LNX.4.61.0704301315080.29151@yvahk01.tjqt.qr>
	 <200704301319.54291.ak@suse.de>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 14:28:59 +0200
Message-Id: <1177936139.4843.17.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 13:19 +0200, Andi Kleen wrote:
> On Monday 30 April 2007 13:15:36 Jan Engelhardt wrote:
> > 
> > On Apr 30 2007 13:00, Andi Kleen wrote:
> > >On Monday 30 April 2007 12:50:09 Christoph Hellwig wrote:
> > >> On Mon, Apr 30, 2007 at 12:28:14PM +0200, Andi Kleen wrote:
> > >> > 
> > >> > Otherwise non GPL modules cannot even do basic operations
> > >> > like disabling interrupts anymore, which would be excessive.
> > >> > 
> > >> > Longer term should split the single structure up into
> > >> > internal and external symbols and not export the internal
> > >> > ones at all.
> > >> > 
> > >> > Signed-off-by: Andi Kleen <ak@suse.de>
> > >> 
> > >> Ingo was dead-set against this and I kinda agree. 
> > >
> > >The problem is that without this non GPL modules cannot even disable
> > >interrupts anymore. That is imho too radical.
> > 
> > Perhaps we can have a paravirt_ops2 that specifically deals with
> > interrupt en/disable, and export that instead?
> 
> Yes that is what the "Longer term ..." paragraph above refers to.
> However it would need some restructuring in the code.

FWIW I think doing this first will be better, exposing _all_ to non GNU
modules will weaken whatever case we might have to take it away later.

So, NACK from me too.

I don't want to hear the whining; but it was allowed in .22, so why
should we not be able to do this in .23.... or whatever.




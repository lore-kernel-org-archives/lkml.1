Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbYDCI1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbYDCI1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 04:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757830AbYDCI0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 04:26:53 -0400
Received: from mail.suse.de ([195.135.220.2]:40904 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757017AbYDCI0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 04:26:52 -0400
Date: Thu, 3 Apr 2008 10:26:51 +0200
From: Nick Piggin <npiggin@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [rfc] SLQB: YASA
Message-ID: <20080403082650.GA20132@wotan.suse.de>
References: <84144f020804030045p44456894lfc006dcdeab6f67c@mail.gmail.com> <20080403075725.GA7514@wotan.suse.de> <20080403171626.0283.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080403171626.0283.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 05:17:39PM +0900, KOSAKI Motohiro wrote:
> Hi 
> 
> > > Why is this not a patch set against SLUB?
> > 
> > It's a completely different design of the core allocator algorithms
> > really.
> > 
> > It probably looks quite similar because I started with slub.c, but
> > really is just the peripheral supporting code and structure. I'm never
> > intending to try to go through the pain of incrementally changing SLUB
> > into SLQB. If SLQB is found to be a good idea, then it could maybe get
> > merged.
> 
> Do you have performance mesurement result?
> I hope see it if possible.
> 
> Thanks! :)

Nothing really interesting, unfortunately. I have run some tests on
various microbenchmarks like tbench and things like that. But I
don't have many good ideas for more meaningful tests where slab
allocation performance is critial. Any suggestions? :)

Thanks,
Nick

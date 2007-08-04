Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbXHDUPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbXHDUPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 16:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbXHDUPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 16:15:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37828 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbXHDUPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 16:15:20 -0400
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       J?rn Engel <joern@logfs.org>, Jeff Garzik <jeff@garzik.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
In-Reply-To: <20070804201142.GA2545@elte.hu>
References: <20070804103347.GA1956@elte.hu>
	 <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	 <20070804163733.GA31001@elte.hu>
	 <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>
	 <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org>
	 <20070804192130.GA25346@elte.hu> <20070804192615.GA25600@lazybastard.org>
	 <alpine.LFD.0.999.0708041246530.5037@woody.linux-foundation.org>
	 <20070804200038.GA31017@elte.hu>  <20070804201142.GA2545@elte.hu>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 04 Aug 2007 13:13:44 -0700
Message-Id: <1186258425.2777.10.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-04 at 22:11 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > +#ifdef CONFIG_FASTATIME
> > +	if (!(flags & (MNT_NOATIME | MNT_NODIRATIME)))
> > +		mnt_flags |= MNT_RELATIME;
> > +#endif
> 
> btw., "relatime" does not seem to make much of a difference, if i do 
> this:
> 
>   ls -l x ; sync
> 
> on a "relatime" mounted filesystem ('x' is a regular file), then there's 
> disk IO for every such command. Only if i mount it noatime,nodiratime do 
> i get zero disk IO. Or my patch is wrong somehow.

do we have reldiratime ?



Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbXLBVrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbXLBVrI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 16:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXLBVq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 16:46:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbXLBVq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 16:46:56 -0500
Date: Sun, 2 Dec 2007 19:46:29 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: bunk@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add EXPORT_SYMBOL(ksize);
Message-ID: <20071202214629.GA15034@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, bunk@kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <200712021743.GBH12983.FHOFVJOMFLOStQ@I-love.SAKURA.ne.jp> <20071202134841.GI15974@stusta.de> <200712030634.CBJ18798.OVFQJSFFOHMtLO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712030634.CBJ18798.OVFQJSFFOHMtLO@I-love.SAKURA.ne.jp>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 03, 2007 at 06:34:20AM +0900, Tetsuo Handa escreveu:
> Hello.
> 
> Adrian Bunk wrote:
> > > mm/slub.c exports ksize(), but mm/slob.c and mm/slab.c don't. I don't know why.
> > That's due to the fact that my patch to remove this unused export from 
> > slub was not yet applied...
> So, removing exports is intended thing?

The ones that are leftovers from past, valid, uses, yes. Kudos to Adrian
for being the zealot in action!
 
> > Where is the modular in-kernel user?
> I don't know.
> But I think ksize() should be available to kernel modules as well as kmalloc() etc.

Why do you think so? You have to justify that with some valid use.
 
- Arnaldo

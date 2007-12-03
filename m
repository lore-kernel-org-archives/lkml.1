Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbXLCVUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbXLCVUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbXLCVUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:20:06 -0500
Received: from waste.org ([66.93.16.53]:51710 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbXLCVUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:20:04 -0500
Date: Mon, 3 Dec 2007 15:19:05 -0600
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Adrian Bunk <bunk@kernel.org>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, acme@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add EXPORT_SYMBOL(ksize);
Message-ID: <20071203211904.GO17536@waste.org>
References: <200712021743.GBH12983.FHOFVJOMFLOStQ@I-love.SAKURA.ne.jp> <20071202134841.GI15974@stusta.de> <200712030634.CBJ18798.OVFQJSFFOHMtLO@I-love.SAKURA.ne.jp> <20071202214629.GA15034@ghostprotocols.net> <200712032041.ABB90643.SOFVQFtMHFLOOJ@I-love.SAKURA.ne.jp> <20071203135700.GR15974@stusta.de> <84144f020712030607v79ebf1e8w8c8b14d2647f1deb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020712030607v79ebf1e8w8c8b14d2647f1deb@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 04:07:33PM +0200, Pekka Enberg wrote:
> Hi,
> 
> On Mon, Dec 03, 2007 at 08:41:44PM +0900, Tetsuo Handa wrote:
> > > We couldn't know how much memory was allocated by kmalloc() in 2.4 era, and we can know it 2.6 era.
> > > But are we going back to 2.4 era for out-of-tree kernel modules?
> 
> On Dec 3, 2007 3:57 PM, Adrian Bunk <bunk@kernel.org> wrote:
> > The interesting fact is that there are zero in-kernel modules using it.
> 
> Yeah, and now that we have krealloc() I don't expect that many callers
> actually need ksize() either.

Yes, most of them ought not exist.

-- 
Mathematics is the supreme nostalgia of our time.

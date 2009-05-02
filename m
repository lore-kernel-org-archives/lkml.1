Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZEBB7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZEBB7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 21:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbZEBB7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 21:59:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40339 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZEBB73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 21:59:29 -0400
Date: Fri, 1 May 2009 19:59:28 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Steve French <smfrench@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Andrew Tridgell <tridge@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
Message-ID: <20090502015927.GJ8822@parisc-linux.org>
References: <524f69650905011318m34e0027dt57877d225b3fe2da@mail.gmail.com> <20090501210109.GA3079@infradead.org> <20090502013729.GI6996@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090502013729.GI6996@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 06:37:29PM -0700, Paul E. McKenney wrote:
> On Fri, May 01, 2009 at 05:01:09PM -0400, Christoph Hellwig wrote:
> > >From the complete lack of technical arguments it's pretty obvious that
> > this seems to be some FUD fallout from the MS vs TomTom patent lawsuite.
> > 
> > I'm not a lawyer so I don't know how much of a threat it is.  But either
> > the case gets shot down by showing prior art and everything is fine, or
> > we indeed are in deep trouble and should remove it completely.  Given
> > the Cc list on here IBM seems to have some legal opinion on it, so can
> > we please see it and discuss what we want to with all cards on the
> > table?
> 
> Hello, Christoph!
> 
> Hmmm...  Both Tridge and Dave have Signed-off-by on the original patch,
> and Steve has Acked-by, Mingming has Cc, and Dave is on the From list
> rather than the Cc list, so I have to guess that there is a good chance
> that you are talking about me.  ;-)
> 
> However, as far as I know, none of us are lawyers, and LKML is definitely
> a technical rather than a legal forum, so we really do need to stick to
> technical topics.  I understand that this might be a bit frustrating
> to you.  On the other hand, I for one much prefer being in a forum
> restricted to technical topics than to be in those places designed to
> handle legal topics!

So what's the purely technical argument for including this patch?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

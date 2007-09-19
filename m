Return-Path: <linux-kernel-owner+w=401wt.eu-S1762625AbXISSQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762625AbXISSQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761580AbXISSQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:16:21 -0400
Received: from pat.uio.no ([129.240.10.15]:38633 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761442AbXISSQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:16:19 -0400
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
In-Reply-To: <20070919180749.GD5946@fieldses.org>
References: <46E94993.3090506@openvz.org>
	 <20070916194135.GC31801@fieldses.org> <46EE20C4.1060405@openvz.org>
	 <20070917145934.GA4957@fieldses.org> <46EF71F0.9010606@openvz.org>
	 <20070919180749.GD5946@fieldses.org>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 14:16:13 -0400
Message-Id: <1190225773.6734.15.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.052)
X-UiO-Scanned: 574FAF622239D3E9C890381231AF1DBF0E41FB23
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 209 total 3988938 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 14:07 -0400, J. Bruce Fields wrote:
> On Tue, Sep 18, 2007 at 10:36:32AM +0400, Pavel Emelyanov wrote:
> > J. Bruce Fields wrote:
> > > I would also prefer a locking scheme that didn't rely on the BKL.  That
> > > said, except for this race:
> > 
> > I would as well :) But I don't know the locking code good enough to
> > start fixing. Besides, even if I send a patch series that handles this,
> > I don't think that anyone will accept it, due to "this changes too much
> > code", "can you prove you fixed all the places" and so on...
> 
> Several people have expressed interest in a locking scheme for locks.c
> (and probably lockd) that doesn't depend on BKL, so I don't think it
> would be ignored.  But, yes, it would have to be done very carefully;
> there have been at least one or two previous attempts that failed.

Another long-term project might be to convert the current list of locks
into a more scalable structure: something like an rbtree might be more
appropriate for really large numbers of locks.

Cheers
  Trond


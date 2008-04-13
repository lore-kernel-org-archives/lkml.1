Return-Path: <linux-kernel-owner+w=401wt.eu-S1752383AbYDMIV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbYDMIV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYDMIVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:21:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601AbYDMIVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:21:06 -0400
Date: Sun, 13 Apr 2008 01:20:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Bob Copeland <me@bobcopeland.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-Id: <20080413012001.8d7967f4.akpm@linux-foundation.org>
In-Reply-To: <20080413080130.GA9622@infradead.org>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
	<20080412170304.54f139e2.akpm@linux-foundation.org>
	<20080413033344.GA27494@hash.localnet>
	<20080412205544.5e12a7d4.akpm@linux-foundation.org>
	<20080413080130.GA9622@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 04:01:30 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, Apr 12, 2008 at 08:55:44PM -0700, Andrew Morton wrote:
> > > it's a dead filesystem that a very few people still have a reason to
> > > use.  If FUSE is where this should live, then I'll just simply focus my
> > > time on that instead (since I already have it in FUSE).
> > 
> > Yes, pursuing the FUSE implementation sounds a better approach - it avoids
> > burdening the kernel with a filesysstem which few will be interested in and
> > is more practical for use by those who _are_ interested in it.
> 
> No way.  For a normal foreign block filesystem a proper kernel
> implementation is much better.  And this one is particularly
> well-written.  Lately I really start wondering why we keep adding crap
> all over the core, but if we have a modular new filesystem that's quite
> nice people start complaining.
> 

I'm not complaining about anything.  Who has?

As the filesystem is for occasional, non-performance-sensitive use
by a very small number of people, doing it via FUSE sounds like an
all-round more practical approach.  This has nothing to do with quality of
implementation at all.

I don't have particularly strong opinions either way.


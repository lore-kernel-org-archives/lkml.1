Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZD1Wr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZD1Wr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbZD1Wrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:47:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45572 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbZD1Wrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:47:46 -0400
Subject: Re: [PATCH 01/12] mutex: add atomic_dec_and_mutex_lock
From: Eric Paris <eparis@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090428132742.7da75691.akpm@linux-foundation.org>
References: <20090427215305.14161.33354.stgit@paris.rdu.redhat.com>
	 <20090428132742.7da75691.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 18:46:00 -0400
Message-Id: <1240958760.11028.23.camel@dhcp231-142.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 13:27 -0700, Andrew Morton wrote:
> On Mon, 27 Apr 2009 17:53:05 -0400
> Eric Paris <eparis@redhat.com> wrote:
> 
> > Much like the atomic_dec_and_lock() function in which we take and hold a
> > spin_lock if we drop the atomic to 0 this function takes and holds the
> > mutex if we dec the atomic to 0.
> 
> I sucked these patches into -mm, mainly for a bit of compile-time and
> runtime testing.
> 
> I read through them all on the previous iteration.  IIRC my main
> impression was that the code and the data structures were not
> sufficiently well commented for that review to have been particularly
> effective.  Hopefully things improved there?

I added hundreds of lines of comments where I hope they will be
useful.....
> 
> It would be good if Al and/or hch and/or others could review this work.
> Christoph has indicated that he will be doing this.
> 
> You didn't reply to all my review comments from last time, but from a
> quick random sample I see that some/most comments have been addressed. 
> Hopefully all were at least considered.

Every comment was considered, I promise!

> It's a little worrisome that my comment against this particular patch
> was lost, and the patch was verbatim merged into Ingo's perfcounter
> branch.  Did anything else get lost?

Actually, by the time you commented on it the patch was already added
and in use in Ingo's tree, which was why I didn't make the change  I
could (and I will) follow up with another patch to make the requested
change rather than change this patch.

-Eric


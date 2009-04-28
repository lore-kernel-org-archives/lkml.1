Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZD1Ufc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZD1Ufc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZD1UfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:35:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbZD1UfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:35:17 -0400
Date: Tue, 28 Apr 2009 13:27:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au, john@johnmccutchan.com,
       rlove@rlove.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 01/12] mutex: add atomic_dec_and_mutex_lock
Message-Id: <20090428132742.7da75691.akpm@linux-foundation.org>
In-Reply-To: <20090427215305.14161.33354.stgit@paris.rdu.redhat.com>
References: <20090427215305.14161.33354.stgit@paris.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 17:53:05 -0400
Eric Paris <eparis@redhat.com> wrote:

> Much like the atomic_dec_and_lock() function in which we take and hold a
> spin_lock if we drop the atomic to 0 this function takes and holds the
> mutex if we dec the atomic to 0.

I sucked these patches into -mm, mainly for a bit of compile-time and
runtime testing.

I read through them all on the previous iteration.  IIRC my main
impression was that the code and the data structures were not
sufficiently well commented for that review to have been particularly
effective.  Hopefully things improved there?

It would be good if Al and/or hch and/or others could review this work.
Christoph has indicated that he will be doing this.

You didn't reply to all my review comments from last time, but from a
quick random sample I see that some/most comments have been addressed. 
Hopefully all were at least considered.

It's a little worrisome that my comment against this particular patch
was lost, and the patch was verbatim merged into Ingo's perfcounter
branch.  Did anything else get lost?

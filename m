Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZJCN5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZJCN5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbZJCN5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:57:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:7227 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbZJCN5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rbeQ88wPb0GcO0UnJGScQbIjMIr/wM09jegaKbqkbDmB0uLhR7NZ3i4lMqHGwRvHXc
         xZ75bAbV80hygxSXOX+9+LNZo/yJXEAQaN9CF/Oce1GM5D6BvYIQfS2YyMmRDOZJfeFQ
         r4TjtanVYnMbfKR/SZ8MvCwOui/Q4go+WHHAM=
Date: Sat, 3 Oct 2009 15:57:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL] tracing: Perf tracing fixes
Message-ID: <20091003135734.GB5617@nowhere>
References: <19140.13582.223629.56214@cargo.ozlabs.ibm.com> <1254577650-5623-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254577650-5623-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 03:47:28PM +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull these .33 tracing fixes from


Hmm, now I realize this code is upstream already.
I should better rebase it against latest Linus's tree.

Sorry.


> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/core
> 
> These address reviews from Paul mackerras.
> 
> I also plan to rename the whole "ftrace event profile" naming to
> "ftrace event perf" soon.
> 
> Thanks.
> 
> Frederic Weisbecker (2):
>       tracing: Check total refcount before releasing bufs in profile_enable failure
>       tracing: Use free_percpu instead of kfree
> 
>  kernel/trace/trace_event_profile.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)


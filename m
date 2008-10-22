Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbYJVRXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbYJVRXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYJVRXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:23:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbYJVRXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:23:30 -0400
Date: Wed, 22 Oct 2008 10:22:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: eranian@gmail.com, "David Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/24] perfmon3: introduction
Message-Id: <20081022102257.60dc8d08.akpm@linux-foundation.org>
In-Reply-To: <200810220958.23266.jbarnes@virtuousgeek.org>
References: <48f8a9a3.0437560a.656a.57c5@mx.google.com>
	<20081021.212502.41487120.davem@davemloft.net>
	<7c86c4470810220139h49269138g844194bd5db3d5c2@mail.gmail.com>
	<200810220958.23266.jbarnes@virtuousgeek.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 09:58:22 -0700 Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Wednesday, October 22, 2008 1:39 am stephane eranian wrote:
> > As you know, I have been involved with this project for quite some time
> > now. I have been through many ups and downs trying to get this merged
> > upstream. So rest assured of my full determination to bring this to the
> > point of success.
> 
> I've been following this at a high level since using perfmon on ia64 several 
> years ago.  I have to say I'm impressed that you've put up with all the review 
> and code churn (which to me often seemed arbitrary) without burning out.
> 
> Honestly I think it sucks that perfmonN isn't upstream yet supporting all the 
> various architectures you've been working with.  You've obviously proven to be 
> a much more responsive and end-user focused maintainer than several of the 
> other fly by night profiling infrastructures we currently have in the kernel 
> (the long abandoned oprofile and perfctr come to mind).
> 
> As I mentioned at KS, I think it's about time we had a single point of contact 
> for profiling in the kernel, to avoid the massive functional duplication we 
> have today and make sure some kind of code sharing occurs; seems to me you'd 
> be a good candidate for that sort of job.
> 
> But regardless, I think it's about time this got merged.  Linus?  Andrew?

It is several years late.  For me the problem has been that we do a lot
of review and have lots of discussion but then the trail goes cold for
six months and when it all pops up again the code has changed and/or
we've all forgotten about it again.

What it needs is a sustained effort to get it over the hump.  How's
about getting it into linux-next asap and then we all agree to do the
re-re-re-review and runtime testing for a 2.6.29 merge?



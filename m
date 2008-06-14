Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbYFNJR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbYFNJR7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 05:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbYFNJRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 05:17:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:55011 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbYFNJRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 05:17:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xx1w/S6Z7R7tr5k00LSwAxZ+2JwVh/I1D/Z5nV2vqJTeKyAhGBuDS2D1VfhXpbnKpL
         tHCsOA5+KCZ+kFhEylx4n7t6Z76DsARioBl/jCfBjRfJHYSjE2uaEs43JedTEjCuQ4b1
         CWRoHWd5pWi9RmMVPp13ncqIS9ygvhiLmTh7M=
Message-ID: <19f34abd0806140217x1ea73a8k1cae18a12128a2b1@mail.gmail.com>
Date: Sat, 14 Jun 2008 11:17:48 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC][PATCH] kmemcheck: divide and conquer
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080614090023.GA13798@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080613140057.GA25833@damson.getinternet.no>
	 <20080614063114.GA24188@elte.hu>
	 <19f34abd0806140139i70a5056ehbd8a6f5df81549e4@mail.gmail.com>
	 <20080614090023.GA13798@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 11:00 AM, Ingo Molnar <mingo@elte.hu> wrote:
> a small workflow request: could you please start adding append-only
> commits to that tree, if possible?

Yes, I will.

> it would be much better if you stopped rebasing kmemcheck from now on,
> and did append-only updates only - that way i could pick up your updates
> into tip/kmemcheck by doing pulls. It does not matter if the result
> looks a bit messier - most of the fundamentals should be in place
> already.

I've created the "for-tip" branch which is (for now) just a copy of
the current "current" branch. This branch ("for-tip") will henceforth
NEVER be rebased.

I won't guarantee this for the other branches, though; rebasing is
really handy when the patch series is to be reviewed since it cuts
down noise to the bare minimum, and avoids multiple changes to the
same area of code (which is confusing to reviewers).

I think I will append new commits to the "for-tip" branch, git-pull
new kernel -rc releases, and rebase the result into a new branch (e.g.
against-v2.6.26*). Now we have two heads which _should_ have exactly
the same content, but where one retains a strictly incremental
history, and the other is easy to read for reviewers. (And comparing
them for differences is trivial; that's just a git-diff.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

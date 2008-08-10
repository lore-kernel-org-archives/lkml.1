Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbYHJXVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbYHJXVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 19:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYHJXU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 19:20:58 -0400
Received: from waste.org ([66.93.16.53]:35557 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbYHJXU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 19:20:57 -0400
Subject: Re: [PATCH 5/5] kmemtrace: SLOB hooks.
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mathieu.desnoyers@polymtl.ca, cl@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <84144f020808101048l7d62c133paf320c48748fe514@mail.gmail.com>
References: <1218388447-5578-1-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-5-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-6-git-send-email-eduard.munteanu@linux360.ro>
	 <84144f020808101048l7d62c133paf320c48748fe514@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 10 Aug 2008 18:18:21 -0500
Message-Id: <1218410301.7576.310.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-08-10 at 20:48 +0300, Pekka Enberg wrote:
> On Sun, Aug 10, 2008 at 8:14 PM, Eduard - Gabriel Munteanu
> <eduard.munteanu@linux360.ro> wrote:
> > This adds hooks for the SLOB allocator, to allow tracing with kmemtrace.
> >
> > We also convert some inline functions to __always_inline to make sure
> > _RET_IP_, which expands to __builtin_return_address(0), always works
> > as expected.
> >
> > Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> 
> I think Matt acked this already but as you dropped the tags, I'll ask
> once more before I merge this.

Yeah, that's fine.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.


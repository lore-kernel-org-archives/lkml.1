Return-Path: <linux-kernel-owner+w=401wt.eu-S1763643AbZDBVS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763643AbZDBVS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760154AbZDBVSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:18:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761719AbZDBVSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:18:01 -0400
Date: Thu, 2 Apr 2009 14:14:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: minyard@acm.org, linux-kernel@vger.kernel.org,
       openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH 4/5] IPMI: Add console oops catcher
Message-Id: <20090402141445.3a7a6504.akpm@linux-foundation.org>
In-Reply-To: <49ADC559.7040705@ct.jp.nec.com>
References: <20090303152123.GD7777@minyard.local>
	<20090303132046.a8975963.akpm@linux-foundation.org>
	<49ADC559.7040705@ct.jp.nec.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Mar 2009 16:03:37 -0800
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> ...
> > This reader is unable to determine what the mystery preempt_disable()
> > is here for.  It needs a comment, please.
> 
> I cannot recall why it's here. So a comment is really needed.
> This preempt_disable() may not be needed.
> 
> > What happens if two CPUs oops at the same time (which is fairly common)?
> 
> ...
>
> OK. I'll look at this.
> 
> > It would be prudent to have a timeout in this loop.  The machine has
> > crashed and subsystems and hardware and memory are in an unknown and
> > possibly bad state.
> 
> Right.
>
> ...
> 
> > This looks like we're abusing the "unblank" method.
> > 
> > If you think that the console subsystem is missing some capability
> > which this driver needs then please do prefer to fix the console
> > subsystem, rather than awkwardly making things fit.
> 
> OK. Will take a look about this point.
> 

None of this happened.

It makes me reluctant to merge that patches as they stand, because then
it all gets forgotten about, whereas holding the patches back will
remind us that updates are needed.



Return-Path: <linux-kernel-owner+w=401wt.eu-S1765423AbYAaJrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765423AbYAaJrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYAaJqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:46:55 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49038 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYAaJqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:46:53 -0500
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <20080130163927.760e94cc.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 30 Jan 2008 16:39:27 -0800)
Subject: Re: [patch 6/6] mm: bdi: allow setting a maximum for the bdi dirty
 limit
References: <20080129154900.145303789@szeredi.hu>
	<20080129154954.275142755@szeredi.hu> <20080130163927.760e94cc.akpm@linux-foundation.org>
Message-Id: <E1JKW0Q-000200-An@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 31 Jan 2008 10:46:50 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 29 Jan 2008 16:49:06 +0100
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Add "max_ratio" to /sys/class/bdi.  This indicates the maximum
> > percentage of the global dirty threshold allocated to this bdi.
> 
> Maybe I'm having a stupid day, but I don't understand the semantics of this
> min and max at all.  I've read the code, and I've read the comments (well,
> I've hunted for some) and I've read the docs.
> 
> I really don't know how anyone could use this in its current state without
> doing a lot of code-reading and complex experimentation.  All of which
> would be unneeded if this tunable was properly documented.
> 
> So.  Please provide adequate documentation for this tunable.  I'd suggest
> that it be pitched at the level of a reasonably competent system operator. 
> It should help them understand why the tunable exists, why they might
> choose to alter it, and what effects they can expect to see.  Hopefully a
> reaonably competent kernel developer can then understand it too.

OK.  I think what's missing from some docs, is a high level
description of the per-bdi throttling algorithm, and how it affects
writeback.  Because with info, I think the min and max ratios are
trivially understandable: they just override the result of the
algorithm, in case it would mean too high or too low threshold.

Peter, could you write something about that?

Thanks,
Miklos

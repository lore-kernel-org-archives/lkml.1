Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbZCYKR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbZCYKR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZCYKRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:17:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38798 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbZCYKRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:17:50 -0400
Date: Wed, 25 Mar 2009 11:17:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] blktrace: fix the original blktrace
Message-ID: <20090325101747.GL27476@kernel.dk>
References: <49C9F700.9070609@cn.fujitsu.com> <49C9F796.9040503@cn.fujitsu.com> <20090325101451.GK2341@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325101451.GK2341@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25 2009, Ingo Molnar wrote:
> 
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > Currently the original blktrace, which is using relay and is used 
> > via ioctl, is broken. You can use ftrace to see the output of 
> > blktrace, but user-space blktrace is unusable.
> 
> good catch, thanks Li!
> 
> Jens, Arnaldo, do these fixes look good to you too?

Look fine, but I'm very worried about the state of the current code. I
mean, this last round of fixes got the timestamp correct and made
blktrace work again. Those are something that should have been caught
even before the whole thing was posted, let alone merged. When do you
plan on pushing this upstream? Looks like 2.6.31 to me, it's clearly not
ready for 2.6.30 by any stretch.

-- 
Jens Axboe


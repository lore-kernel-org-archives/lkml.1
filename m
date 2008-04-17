Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbYDQIVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbYDQIVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYDQIVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:21:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754173AbYDQIVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:21:10 -0400
Date: Thu, 17 Apr 2008 01:20:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417012051.ed56f4ab.akpm@linux-foundation.org>
In-Reply-To: <84144f020804170045s24cbb802u3358ec6b5d391a10@mail.gmail.com>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<84144f020804170045s24cbb802u3358ec6b5d391a10@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 10:45:59 +0300 "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On Thu, Apr 17, 2008 at 10:25 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >  > Soren Sandmann (1):
> >  >       x86: add the debugfs interface for the sysprof tool
> >
> >  Also, I (and apparently only I) actually reviewed the implementation and
> >  found it to be riddled with bugs and shortcomings.  afacit this was
> >  completely ignored and you propose to merge it anwyay?
> 
> No, I fixed some of those and I think Ingo/Soren did the rest. But it
> needs another round of review on LKML for sure.

afaict none of my review comments have been addressed in the sysprof.c which
is in -mm.  It has the following commits:

    x86, sysprof: merge header to compilation unit
    x86, sysprof: clean up stack frame copying
    x86, sysprof: remove dead code
    sysprof: user pointer verification
    sysprof: minor cleanups
    x86: add the debugfs interface for the sysprof tool

I received no email even acknowledging the review comments.

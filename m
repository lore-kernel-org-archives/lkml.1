Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbXEKUSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbXEKUSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbXEKUSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:18:30 -0400
Received: from twin.jikos.cz ([213.151.79.26]:58963 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbXEKUS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:18:29 -0400
Date: Fri, 11 May 2007 22:18:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kratochvil <honza@jikos.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] PIE randomization
In-Reply-To: <20070511125629.3df919cf.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz>
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz>
 <20070511125629.3df919cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, Andrew Morton wrote:

> >    I sent this patch 5 days ago, nobody replied. So I am giving it 
> > second attempt. Andrew, is it possible to test this in -mm branch? 
> > Original mail follows:
> >     this is something like reaction to this thread: 
> > http://lkml.org/lkml/2007/1/6/124. I hope I was able to separate the 
> > PIE randomization part correctly.
> I don't know what to do with this.  The changelog doesn't tell me what PIE
> randomization _is_, nor why the kernel would want to do it. "Randomizing 
> -pie compiled binaries" sounds fairly undesirable, actually ;)

I think it's precisely what we want to do in case the randomize_va_space 
is set to 1, don't we? (I haven't yet gone throught the patch though, so I 
am not sure whether this is the case).

We already have stack randomization and mmap() base randomization but 
executable base randomization (which is of course only feasible for -pie 
executables) and brk() randomization still seem to be missing to make it 
complete.

-- 
Jiri Kosina
SUSE Labs

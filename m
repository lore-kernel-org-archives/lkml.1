Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbYD0Kgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbYD0Kgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 06:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYD0Kgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 06:36:42 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27925 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbYD0Kgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 06:36:42 -0400
Date: Sun, 27 Apr 2008 12:36:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
Message-ID: <20080427103637.GV12774@kernel.dk>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-2-git-send-email-jens.axboe@oracle.com> <20080425231100.b93a1601.akpm@linux-foundation.org> <20080427005816.GB21687@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427005816.GB21687@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26 2008, Paul E. McKenney wrote:
> On Fri, Apr 25, 2008 at 11:11:00PM -0700, Andrew Morton wrote:
> > > On Tue, 22 Apr 2008 20:50:17 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> > > This adds kernel/smp.c which contains helpers for IPI function calls. In
> > > addition to supporting the existing smp_call_function() in a more efficient
> > > manner, it also adds a more scalable variant called smp_call_function_single()
> > > for calling a given function on a single CPU only.
> 
> Where is the new smp_call_function() defined?  I see only the declaration.
> 
> Probably just blind...

kernel/smp.c? Basically just a wrapper around smp_call_function_mask().

> See comments interspersed below.

Thanks a lot! I'll go over these tomorrow, the fallback graceperiod
definitely looks valid.

-- 
Jens Axboe


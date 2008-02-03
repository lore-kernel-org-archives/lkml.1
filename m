Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbYBCTsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbYBCTsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 14:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYBCTs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 14:48:27 -0500
Received: from xyzzy.farnsworth.org ([65.39.95.219]:56302 "EHLO
	xyzzy.farnsworth.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYBCTs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 14:48:26 -0500
Date: Sun, 3 Feb 2008 12:47:56 -0700
From: Dale Farnsworth <dale@farnsworth.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <20080203194756.GA28783@farnsworth.org>
References: <20080201152106.GA21534@farnsworth.org> <1202052062.32654.69.camel@lappy>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1202052062.32654.69.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
Subject: Re: [PATCH] lockdep: Include all lock classes in all_lock_classes
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 04:21:02PM +0100, Peter Zijlstra wrote:
> On Fri, 2008-02-01 at 08:21 -0700, Dale Farnsworth wrote:
> > Add each lock class to the all_lock_classes list when it is
> > first registered.
> > 
> > Previously, lock classes were added to all_lock_classes when
> > the lock class was first used. 
> 
> > Since one of the uses of the list is to find unused locks, this didn't
> > work well.
> 
> You mean in lockdep_proc.c to generate the statistics?

Yes, that's where I noticed it.  On my platform, there was one
unused lock which was missed.
> 
> Another potential issue might be count_matching_names() generating a
> wrong class version.

I haven't looked into that issue yet.

-Dale

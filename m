Return-Path: <linux-kernel-owner+w=401wt.eu-S933137AbXJQP3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137AbXJQP3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759637AbXJQP3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:29:35 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1380 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049AbXJQP3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:29:34 -0400
Date: Wed, 17 Oct 2007 16:29:16 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.23-git8 kernel oops at __rb_rotate_left+0x7/0x70
Message-ID: <20071017152916.GH21136@shadowen.org>
References: <47144B4F.3050108@linux.vnet.ibm.com> <20071017142140.GA8634@elte.hu> <20071017150056.GA28135@linux.vnet.ibm.com> <20071017145226.GA21676@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017145226.GA21676@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 04:52:26PM +0200, Ingo Molnar wrote:

> > We (myself, Kamalesh and Dhaval) have tested the patch below, w/o 
> > being able to recreate the problem. The patch allows for 
> > task_new_fair() to be called even for the case when child is being 
> > added to another cpu's runqueue.
> 
> yes, and your fix is the better one, it goes into the next batch of 
> fixes.

Have that patch submitted too.  Somewhen we'll have some more results.

-apw

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764864AbXJQOo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764864AbXJQOo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbXJQOoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:44:20 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1637 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070AbXJQOoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:44:19 -0400
Date: Wed, 17 Oct 2007 15:43:52 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.23-git8 kernel oops at __rb_rotate_left+0x7/0x70
Message-ID: <20071017144352.GF21136@shadowen.org>
References: <47144B4F.3050108@linux.vnet.ibm.com> <20071017142140.GA8634@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017142140.GA8634@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 04:21:40PM +0200, Ingo Molnar wrote:
> 
> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > While running kernbench with the 2.6.23-git8 following oops is 
> > produced
> 
> Dmitry found something that might explain the crash: could you check 
> whether the patch below fixes it?
> 
> 	Ingo
> 
> ---------------------->
> Subject: sched: fix new task startup crash
> From: Ingo Molnar <mingo@elte.hu>
> 
> this should fix the put_prev_task crashes that were reported,
> Dmitry Adamushko noticed that it's not valid to call into
> task_new_fair() if this_cpu != task_cpu(p).
> 
> Reported-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Reported-by: Andy Whitcroft <apw@shadowen.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

I have submitted jobs against a couple of the releases which showed this
problem with this patch.  They will be a while as there are other tests
running at the moment.  Will let you know when they are done.

-apw

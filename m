Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYCJNaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYCJNaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYCJNab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:30:31 -0400
Received: from 74-92-59-67-NewEngland.hfc.comcastbusiness.net ([74.92.59.67]:59994
	"EHLO shelob.surriel.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbYCJNaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:30:30 -0400
Date: Mon, 10 Mar 2008 09:30:24 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: Re: [PATCH -mm] extend sysrq-p functionality to cover all CPUs
Message-ID: <20080310093024.55a4ff90@bree.surriel.com>
In-Reply-To: <20080309224759.6fead9af.akpm@linux-foundation.org>
References: <20080309221458.20642e48@bree.surriel.com>
	<20080309224759.6fead9af.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008 22:47:59 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 9 Mar 2008 22:14:58 -0400 Rik van Riel <riel@surriel.com> wrote:
> 
> > SysRP-P is not all that useful on SMP systems, since the sysrq
> > irq rarely ends up on the CPU that we actually want to investigate.

> Doesn't everyone have a copy of this somewhere? ;)

Yes, but the old version of the patch calls on_each_cpu from
sysrq context, which is illegal since it could cause a deadlock.
 
> However it does have the downside that info can scroll away on large cpu
> counts.  Maybe it should be a new sysrq command?

It used to be sysrq-w in the patches that everybody has, but that
letter got taken for sysrq_showstate_blocked_op.

Only sysrq h, j, l, y and z are still free.  H is needed for help,
leaving just j, l, y and z.

I can see your point about overflowing the screen, however just
sysrq-p seems like a waste to have because it will probably not
print anything useful on a large CPU system...

If you still want it to be a separate letter, just let me know
which one of the last four I should take.

-- 
All rights reversed.

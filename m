Return-Path: <linux-kernel-owner+w=401wt.eu-S935713AbXGRAyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935713AbXGRAyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbXGRAyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:54:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48180 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757582AbXGRAyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:54:45 -0400
Date: Tue, 17 Jul 2007 17:53:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
       devel@openvz.org, Thomas Gleixner <tglx@linutronix.de>,
       stable@kernel.org
Subject: Re: [PATCH] Fix leaks on
 /proc/{*/sched,sched_debug,timer_list,timer_stats}
Message-Id: <20070717175346.da0899f3.akpm@linux-foundation.org>
In-Reply-To: <20070717123511.GB17657@elte.hu>
References: <20070717122511.GD25083@localhost.sw.ru>
	<20070717123511.GB17657@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 14:36:10 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Alexey Dobriyan <adobriyan@sw.ru> wrote:
> 
> > On every open/close one struct seq_operations leaks.
> > Kudos to /proc/slab_allocators.
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> 
> ouch ...
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> -stable material too, as far as timer_info/stats goes.

So I have a patch which will not fully apply to -stable.

Sorry, but I can't be bothered splitting it up.  Greg, Chris: please just
apply the bits which apply and drop the other bits if that's OK.


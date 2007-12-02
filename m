Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbXLBWUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbXLBWUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 17:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbXLBWUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 17:20:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56680 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbXLBWUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 17:20:03 -0500
Date: Sun, 2 Dec 2007 14:18:25 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202141825.063356a2@laptopd505.fenrus.org>
In-Reply-To: <20071202211925.GA26414@one.firstfloor.org>
References: <20071201092037.GA32544@elte.hu>
	<p737ijwylet.fsf@bingen.suse.de>
	<20071202185945.GA25990@elte.hu>
	<20071202114152.3bf4332d@laptopd505.fenrus.org>
	<20071202200953.GA23994@one.firstfloor.org>
	<20071202202602.GA16480@elte.hu>
	<20071202204725.GA25891@one.firstfloor.org>
	<20071202211027.GA32282@elte.hu>
	<20071202211925.GA26414@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007 22:19:25 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > 
> > Until now users had little direct recourse to get such problems
> > fixed. (we had sysrq-t, but that included no real metric of how
> > long a task was 
> 
> Actually task delay accounting can measure this now.  iirc someone
> had a latencytop based on it already.


I have written a latencytop tool, but it's not based quite on the task
delay accounting (it doesn't provide the right information to make such
a tool). I've not released the tool mostly because I'm not quite happy
about the kernel side yet... but if there's real interest I'll fix it
up soon and release it.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

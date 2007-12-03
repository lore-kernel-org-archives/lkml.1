Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbXLCORs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbXLCORs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 09:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbXLCORl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 09:17:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56445 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbXLCORk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 09:17:40 -0500
Date: Mon, 3 Dec 2007 15:17:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071203141739.GC4719@one.firstfloor.org>
References: <20071203110412.GD28560@one.firstfloor.org> <20071203115900.GB8432@elte.hu> <20071203121357.GB2986@one.firstfloor.org> <20071203122833.GA20232@elte.hu> <20071203124144.GC2986@one.firstfloor.org> <20071203130003.GA26372@elte.hu> <20071203131442.GA4004@one.firstfloor.org> <20071203132955.GA31354@elte.hu> <20071203134801.GB4004@one.firstfloor.org> <20071203135547.GA4245@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203135547.GA4245@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 02:55:47PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > I would still appreciate if you could state what default value you 
> > plan to set the backtrace sysctl to in the submitted patch.
> 
> there's no "backtrace sysctl" planned for the moment. This "hung tasks" 

I hope you'll reconsider that at least before submitting 
this patch to mainline. For -mm it's probably ok.

> debugging feature can be disabled/enabled on a wide scale already:
> 
>  - in the .config
> 
>  - runtime, temporarily, via:
> 
>      echo 0 > /proc/sys/kernel/hung_task_timeout_secs

That won't address my concerns about already "breaking" (as in 
frightening the user etc.) common error handling scenarios by default.

-Andi


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbXLCAAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbXLCAAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 19:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXLCAAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 19:00:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47599 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbXLCAAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 19:00:04 -0500
Date: Mon, 3 Dec 2007 01:00:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Message-ID: <20071202235959.GA26636@one.firstfloor.org>
References: <20071201092037.GA32544@elte.hu> <p737ijwylet.fsf@bingen.suse.de> <20071202185945.GA25990@elte.hu> <20071202114152.3bf4332d@laptopd505.fenrus.org> <20071202200953.GA23994@one.firstfloor.org> <20071202202602.GA16480@elte.hu> <20071202204725.GA25891@one.firstfloor.org> <20071202211027.GA32282@elte.hu> <20071202211925.GA26414@one.firstfloor.org> <20071202222040.GA31707@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071202222040.GA31707@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Delay accounting (or the /proc/<PID>/sched fields that i added recently) 
> only get updated once a task has finished its unreasonably long delay 
> and has scheduled. 

If it is stuck forever then you can just use sysrq-t

If it recovers delay accounting will catch it.

> detected_ this way. This is a debugging facility that clearly belongs 
> into the kernel. 

My worry is that it will flag various legitimate cases. So far 
you seem to try to just hand-wave them away.

-Andi

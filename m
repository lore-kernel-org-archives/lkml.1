Return-Path: <linux-kernel-owner+w=401wt.eu-S1761098AbZDQNuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098AbZDQNuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760751AbZDQNuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:50:05 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:35285 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760926AbZDQNuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:50:03 -0400
Date: Fri, 17 Apr 2009 09:42:30 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
In-Reply-To: <1239951613.23397.4107.camel@laptop>
Message-ID: <alpine.DEB.1.10.0904170941020.11877@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com> <1239951613.23397.4107.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009, Peter Zijlstra wrote:

> This has never been true afaikt, as long as we have a task running, we
> take the interrupt, I just looked at the .22 code and that certainly
> expects the scheduler_tick() to be called when there is a running
> process.
>
> Also, look at /proc/interrupts if you want to determine interrupt
> frequency.

I am mainly interested in limited the number and length of cpu holdoffs.

If the timer interrupt is always taken then it must take less than 1 usec
in certain versions of the kernel in order to not show up in the
statistics gathered.



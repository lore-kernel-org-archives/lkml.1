Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZESUw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZESUw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 16:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZESUwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 16:52:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbZESUwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 16:52:49 -0400
Date: Tue, 19 May 2009 13:52:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] core kernel fixes
In-Reply-To: <alpine.LFD.2.00.0905181801250.3516@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0905191348140.3301@localhost.localdomain>
References: <20090518142301.GA22765@elte.hu> <alpine.LFD.2.01.0905180840420.3301@localhost.localdomain> <alpine.LFD.2.00.0905181801250.3516@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 May 2009, Thomas Gleixner wrote:
> 
> So we always had that write=0 mapping. And we did not notice that we
> always faulted in the futex functions which modify the user space
> variable simply because the fault was fixed up in the private futex
> fault handling code. The removal of that code led to the problem which
> we have right now.
> 
> Correct fix below.

Ok, this looks fine to me. 

Should I take it like this, or pull from something?

		Linus

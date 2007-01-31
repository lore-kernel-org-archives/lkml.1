Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbXAaFRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbXAaFRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 00:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbXAaFRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 00:17:04 -0500
Received: from gate.crashing.org ([63.228.1.57]:38261 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbXAaFRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 00:17:03 -0500
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	 <1170209044.26655.364.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 16:16:16 +1100
Message-Id: <1170220576.26655.381.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> NOTE! This is with the understanding that we *never* do any preemption. 
> The whole point of the microthreading as far as I'm concerned is exactly 
> that it is cooperative. It's not preemptive, and it's emphatically *not* 
> concurrent (ie you'd never have two fibrils running at the same time on 
> separate CPU's).

That makes it indeed much less worrisome...

> If you want preemptive of concurrent CPU usage, you use separate threads. 
> The point of AIO scheduling is very much inherent in its name: it's for 
> filling up CPU's when there's IO.

Ok, I see, that's in fact pretty similar to some task switching hack I
did about 10 years ago on MacOS to have "asynchronous" IO code be
implemented linearily :-)

Makes lots of sense imho.

Ben.



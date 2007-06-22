Return-Path: <linux-kernel-owner+w=401wt.eu-S1760107AbXFVRfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbXFVRfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbXFVRfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:35:34 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:57327 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbXFVRfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:35:33 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
In-Reply-To: <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 13:31:42 -0400
Message-Id: <1182533502.5493.88.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 10:16 -0700, Linus Torvalds wrote:
> 

> So patches 1-4 all look fine to me. In fact, 5 looks ok too.

Great!

> Leaving patch 6 as a "only makes sense after we actually have some numbers 
> about it", and patch 5 is a "could go either way" as far as I'm concerned 
> (ie I could merge it together with the 1-4 series, but I think it's 
> equally valid to just see it as a companion to 6).

Actually, in my next series, I removed patch 5 and just simply replace
the tasklets with the workqueue implementation, leaving no config
option. It will be out shortly, after I finish my testing.

I also keep the file name tasklet_work.c instead of overwriting
tasklet.c, just because it's easier to review the patch that way.

-- Steve





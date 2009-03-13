Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbZCMD2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbZCMD2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZCMD2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:28:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57733 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbZCMD2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:28:37 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 05/16] tracing: show that buffer size is not expanded
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <alpine.DEB.2.00.0903122317280.18396@gandalf.stny.rr.com>
References: <20090313114953.43E2.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0903122317280.18396@gandalf.stny.rr.com>
Message-Id: <20090313122458.43EE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 13 Mar 2009 12:28:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  # cat /debug/tracing/buffer_size_kb
> > > 7 (expanded: 1408)
> > 
> > Hi,
> > 
> > I have one question.
> > Why souldn't use following output?
> > 
> > sprintf(buf, "%lu\n", trace_buf_size >> 10);
> > 
> > 
> > My point is:
> >   - pure number output can hadle easily.
> >   - nobody need to know internal memory saving logic.
> 
> My answer to the second point is: "I do" ;-)
> 
> I like to know the real buffer size. That '7' comes from the ring buffer 
> size directly. If something is going wrong, I do not want to hide the fact 
> that the ring buffer size is not what I expect it to be. Lets say someone 
> modifies the code, and we miss expanding the buffer. It will be very hard 
> to debug why we are getting a small trace. But if we see that the buffer 
> has not been expanded, we know exactly what is wrong.

ok. understanding.
please ignore my last mail.

Thanks!



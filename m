Return-Path: <linux-kernel-owner+w=401wt.eu-S1030193AbXAZO1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030193AbXAZO1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030304AbXAZO1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:27:45 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:43142 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030193AbXAZO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:27:44 -0500
Subject: Re: Preemption patches available in main stream
From: Steven Rostedt <rostedt@goodmis.org>
To: public@wolff-online.nl
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070107215843.21080.qmail@www.wolff-online.nl>
References: <20070107215843.21080.qmail@www.wolff-online.nl>
Content-Type: text/plain
Date: Fri, 26 Jan 2007 09:27:39 -0500
Message-Id: <1169821659.26770.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-01-07 at 22:58 +0100, public@wolff-online.nl wrote:
> Hello, 
> 
> sorry to ask, will the preemption patches of Ingo Molnar come into the 
> mainstream kernel? Or is this already the case? 

Robert Love's preemption patches that turned the kernel into a
preemptible kernel made it in back in 2.5.

I guess you are talking about Ingo Molnar's -rt patch.  Parts of it has
made it into upstream. For example, the priority inheritance of futexes,
as well as robust mutexes. As well as some of Thomas Gleixner's hrtimer
code.

The rest is still maintained at the usual place
(http://people.redhat.com/mingo/realtime-preempt).

As for that going into mainline?  Well that's still on the drawing
board ;)

-- Steve



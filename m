Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbXE3PXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbXE3PXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbXE3PXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:23:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:6779 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbXE3PXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:23:18 -0400
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20070530132431.GA23947@elte.hu>
References: <20070529125248.877196281@chello.nl>
	 <20070529130107.112347096@chello.nl>
	 <1180470525.32594.71.camel@imap.mvista.com>
	 <20070530132431.GA23947@elte.hu>
Content-Type: text/plain
Date: Wed, 30 May 2007 08:20:32 -0700
Message-Id: <1180538432.32594.127.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 15:24 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > [...] Most architecture implement a jiffies sched_clock() w/ 1 
> > millisecond or worse resolution.. [...]
> 
> weird that you count importance by 'number of architectures', while 98% 
> of the installed server base is x86 or x86_64, where sched_clock() is 
> pretty precise ;-)

I work with many other architectures, so it's important to me. That's
aside anyway, just consider there are several Linux architectures. When
we write code we should consider those other architectures .. Non-x86
Linux is used pretty frequently. Dare I say that x86 and x86_64
installations combined don't out weigh all the other architecture
installations, that's only a guess but I wouldn't be surprised if that's
true.

Daniel


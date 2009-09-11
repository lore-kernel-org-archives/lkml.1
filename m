Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbZIKHhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbZIKHhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZIKHhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:37:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:33302 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbZIKHhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:37:52 -0400
Subject: Re: [PATCH 0/3] resend, cpuset/hotplug fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <4AA9F902.4030306@cn.fujitsu.com>
References: <20090910192153.GA584@redhat.com>
	 <1252615996.7205.99.camel@laptop>  <4AA9F902.4030306@cn.fujitsu.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 09:37:39 +0200
Message-Id: <1252654659.7126.2.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 15:15 +0800, Lai Jiangshan wrote:
> 
> I have different concept. cpuset_cpus_allowed() is not called at atomic
> context nor non-preemptable context nor other critical context.
> So it should be allowed to use mutexs. That's what I think.

It hardly does any work at all, so why bother with a mutex?


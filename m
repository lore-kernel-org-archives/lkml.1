Return-Path: <linux-kernel-owner+w=401wt.eu-S933994AbZDJJ1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994AbZDJJ1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762193AbZDJJ05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:26:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762180AbZDJJ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:26:56 -0400
Date: Fri, 10 Apr 2009 02:18:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] sysctl:  lockdep support for sysctl reference
 counting.
Message-Id: <20090410021854.65c6662a.akpm@linux-foundation.org>
In-Reply-To: <m1ab7fxqxw.fsf_-_@fess.ebiederm.org>
References: <49B91A7E.76E4.0078.0@novell.com>
	<tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org>
	<1236934491.5188.209.camel@laptop>
	<49BA33BE.76E4.0078.0@novell.com>
	<1236937423.22914.3698.camel@twins>
	<20090313103828.GB31094@elte.hu>
	<m1d4cd9n4k.fsf@fess.ebiederm.org>
	<20090320085205.GB16021@elte.hu>
	<m14oxo8qis.fsf@fess.ebiederm.org>
	<20090320182404.GA31629@elte.hu>
	<1237575134.4667.5.camel@laptop>
	<1237577688.4667.68.camel@laptop>
	<m1iqm3xr2n.fsf_-_@fess.ebiederm.org>
	<m1eiwrxr05.fsf_-_@fess.ebiederm.org>
	<m1ab7fxqxw.fsf_-_@fess.ebiederm.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009 00:42:19 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:

> It is possible for get lock ordering deadlocks between locks
> and waiting for the sysctl used count to drop to zero.  We have
> recently observed one of these in the networking code.
> 
> So teach the sysctl code how to speak lockdep so the kernel
> can warn about these kinds of rare issues proactively.

`make headers_check':

/usr/src/25/usr/include/linux/sysctl.h:31: included file 'linux/lockdep.h' is not exported
make[2]: *** [/usr/src/25/usr/include/linux/.check] Error 1

It looks like we'll need version 2 on these patches..

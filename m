Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZDXX1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZDXX1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 19:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZDXX0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 19:26:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753983AbZDXX0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 19:26:37 -0400
Date: Fri, 24 Apr 2009 16:20:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: zhaolei@cn.fujitsu.com, mingo@elte.hu, kosaki.motohiro@jp.fujitsu.com,
       rostedt@goodmis.org, tzanussi@gmail.com, linux-kernel@vger.kernel.org,
       oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
 worklet lifecycle tracing
Message-Id: <20090424162056.45907fef.akpm@linux-foundation.org>
In-Reply-To: <20090424225909.GA6658@nowhere>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com>
	<20090415011533.GI5968@nowhere>
	<20090415141250.AC46.A69D9226@jp.fujitsu.com>
	<49E8282A.6010004@cn.fujitsu.com>
	<49E82CA7.2040606@cn.fujitsu.com>
	<20090417134557.GA23493@elte.hu>
	<49F1A59B.3080206@cn.fujitsu.com>
	<20090424130616.a3c217cb.akpm@linux-foundation.org>
	<20090424225909.GA6658@nowhere>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009 00:59:10 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 
> [useful info]
>

OK, thanks.  It was waaaay more useful than the original description.

> So this latest patchset provides all these required informations on the events
> tracing level.

Well.. required by who?

I don't recall ever seeing any problems of this nature, nor patches to
solve any such problems.  If someone wants to get down and optimise our use
of workqueues then good for them, but that exercise doesn't require the
permanent addition of large amounts of code to the kernel.

The same amount of additional code and additional churn could be added
to probably tens of core kernel subsystems, but what _point_ is there
to all this?  Who is using it, what problems are they solving?

We keep on adding all these fancy debug gizmos to the core kernel which look
like they will be used by one person, once.  If that!

> The next step is likely to be on the stat tracing to provide the avg/max time
> of execution.

eek.

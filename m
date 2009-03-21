Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZCUVnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZCUVnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 17:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZCUVnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 17:43:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751417AbZCUVnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 17:43:37 -0400
Date: Sat, 21 Mar 2009 14:34:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-Id: <20090321143413.75ead1aa.akpm@linux-foundation.org>
In-Reply-To: <20090321154501.GA2707@elte.hu>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com>
	<20090321014244.9ADF1FC3AB@magilla.sf.frob.com>
	<20090321074301.GA19384@elte.hu>
	<20090321013912.ed6039c9.akpm@linux-foundation.org>
	<20090321091235.GA29678@elte.hu>
	<20090321041954.72b99e69.akpm@linux-foundation.org>
	<20090321115141.GA3566@redhat.com>
	<20090321050422.d1d99eec.akpm@linux-foundation.org>
	<20090321154501.GA2707@elte.hu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009 16:45:01 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> [...]
>

useful, thanks.

> Putting utrace upstream now will just make it more 
> convenient to have SystemTap as a separate entity - without any of 
> the benefits. Do we want to do that? Maybe, but we could do better i 
> think.

It would not be good to merge a large kernel feature which kernel
developers and testers cannot test, and regression test.

If testing utrace against its main application requires installation of a
complete enterprise distro from a distro which the particular developer
might not prefer to use then that's quite a problem.

So it is desirable for this reason (and, I suspect, for other reasons) that
systemtap (or a part thereof) be dragged out in some standalone form which
is usable by random mortals.

IOW: I agree.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYIWSE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYIWSE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYIWSES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:04:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55062 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbYIWSER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:04:17 -0400
Date: Wed, 24 Sep 2008 02:59:37 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: Unified tracing buffer
Cc: kosaki.motohiro@jp.fujitsu.com, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
In-Reply-To: <48D90970.3060409@redhat.com>
References: <20080923232239.DC1E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48D90970.3060409@redhat.com>
Message-Id: <20080924025457.DC24.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I can't imazine a merit of the single-channel mode.
> > Could you please explain it?
> 
> Actually, single-channel mode is for not-frequently event tracing.
> At least systemtap case, sometimes we just want to collect data
> and watch it periodically(as like as 'top'). Or, just monitoring
> errors as additional printk. in these cases, overhead is not so
> important.
> 
> I think the main reason of using single-channel mode is simplicity of
> userspace reader. We can use 'cat' or 'tail' to read the buffer on-line.
> I'm not sure how much overhead ftrace-like buffer merging routine has,
> but if kernel provides an interface which gives us single-merged buffer
> image(like ftrace buffer), we are grad to use it. :-)

Yup, I also think it is better.

Thanks.




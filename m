Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbYIWOix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbYIWOix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYIWOiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:38:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52392 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYIWOip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:38:45 -0400
Date: Tue, 23 Sep 2008 23:36:26 +0900 (JST)
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
In-Reply-To: <48D81B5F.2030702@redhat.com>
References: <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com>
Message-Id: <20080923232239.DC1E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> By the way, systemtap uses two modes;
> 
> - single-channel mode
>  In this mode, all cpus share one buffer channel to write and read.
>  each writer locks spinlock and write a probe-local data to buffer.
> 
> - per-cpu buffer mode
>  In this mode, we use an atomic sequential number for ordering data. If
>  user doesn't need it(because they have their own timestamps), they can
>  choose not to use that seq-number.

I can't imazine a merit of the single-channel mode.
Could you please explain it?

Because some architecture don't have fine grained timestamp?
if so, could you explain which architecture don't have it?




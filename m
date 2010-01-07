Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680Ab0AGODh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab0AGODh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216Ab0AGODg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:03:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43858 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab0AGODg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:03:36 -0500
X-Authority-Analysis: v=1.0 c=1 a=-aGSfi4y-wgA:10 a=7U3hwN5JcxgA:10 a=3jR3nkstdHY7jJ3NkscA:9 a=dXkDNJ-gfsApRfVrgN1hiD3c7joA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] trace_syscalls: cleanup for syscalls_metadata
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4B453280.7040800@cn.fujitsu.com>
References: <4B448499.6080609@cn.fujitsu.com>
	 <1262797070.28171.2972.camel@gandalf.stny.rr.com>
	 <4B453280.7040800@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 07 Jan 2010 09:03:34 -0500
Message-ID: <1262873014.28171.3714.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 09:01 +0800, Lai Jiangshan wrote:
> Steven Rostedt wrote:

> It seems that there is no spec/document guarantees it.
> 
> I searched all NR_syscalls in current kernel source code,
> and I found it is a constant in header file (all archs).
> 
> trace_syscalls.c has already used it as a compile-time constant:
> 
> static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
> static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);

I guess no one complained about that yet. But that could be because no
one noticed.

Still, is there a reason to make that change other than just a "clean
up"?  What advantage do we have by changing the array into a static
array instead of allocating it at run time?

-- Steve



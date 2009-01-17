Return-Path: <linux-kernel-owner+w=401wt.eu-S933615AbZAQCTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615AbZAQCTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:19:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbZAQCSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:18:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52935 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453AbZAQCSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:18:49 -0500
Subject: Re: WARNING: at kernel/trace/ftrace.c:434 ftrace_bug+0xdb/0x2b1()
 in 2.6.29-rc1-next-20090116
From: Eric Paris <eparis@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0901161939320.9232@gandalf.stny.rr.com>
References: <1232144843.6614.14.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0901161939320.9232@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 21:18:36 -0500
Message-Id: <1232158716.6614.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 19:47 -0500, Steven Rostedt wrote:
> # mount -t debugfs none /sys/kernel/debug
> # cat /sys/kernel/debug/tracing/dyn_ftrace_total_info

[root@unused ~]# cat /sys/kernel/debug/tracing/dyn_ftrace_total_info 
0 0 0

> And perhaps, if possible, could I get a copy of the vmlinux that was 
> built, and a CONFIG to go with it.

check out http://people.redhat.com/~eparis/ftrace

You should find my config, the vmlinux, and my serial capture on that
page.  I'll build again right now without all of my filesystem
notification patches to make sure they aren't somehow screwing things up
(but I pretty seriously doubt it.)

-Eric


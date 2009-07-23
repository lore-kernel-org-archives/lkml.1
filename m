Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbZGWT4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbZGWT4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbZGWT4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:56:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54161 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751658AbZGWT4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:56:09 -0400
Date: Thu, 23 Jul 2009 15:56:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
 breakpoints
In-Reply-To: <1248371110.4681.1.camel@laptop>
Message-ID: <Pine.LNX.4.44L0.0907231555050.3509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009, Peter Zijlstra wrote:

> > Is there a limit to these hardware breakpoints? If so, the software

Certainly there's a limit.  They require hardware resources, after all.

> > counter model is not sufficient, since we assume we can always schedule
> > all software counters. However if you were to add more counters than you
> > have hardware breakpoints you're hosed.
> 
> Do the breakpoints work on virtual or physical addresses?

On x86, hardware breakpoints take virtual addresses.  I don't know 
about other architectures.

Alan Stern


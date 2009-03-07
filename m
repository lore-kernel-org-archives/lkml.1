Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbZCGMPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbZCGMPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 07:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZCGMPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 07:15:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:51685 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZCGMPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 07:15:35 -0500
Subject: Re: [RFC][PATCH 0/2] Syscalls tracing
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1236401580-5758-1-git-send-email-fweisbec@gmail.com>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Date: Sat, 07 Mar 2009 13:15:18 +0100
Message-Id: <1236428118.6376.239.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-07 at 05:52 +0100, Frederic Weisbecker wrote:
> Here is a first attempt, quick one-shot, to provide a syscall tracing
> infrastructure on ftrace.
> 
> The RFC prefix is here to reflect its ugliness on various parts.
> The compromise between tracing reliabilty and speed is hard to balance.
> For example I guess the basic and horrid string mask should be dropped in favour
> of something else, which takes care of the volatile strings from the userspace.
> 
> But I hope a lot of ideas to make it better will come along this discussion.

Can't you abuse the SYSCALL_DEFINE macros? This current approach looks
like it will replicate the syscall table.




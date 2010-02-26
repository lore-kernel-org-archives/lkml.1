Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab0BZFl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 00:41:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62902 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab0BZFl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 00:41:27 -0500
X-Authority-Analysis: v=1.0 c=1 a=jIbXHJqpia4A:10 a=2IsKBkzSBXPv04T90fIA:9 a=NpLHK-RTsT19oLn-J0dwS5YN_TYA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100226053831.050130780@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 26 Feb 2010 00:38:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>, Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 0/2 v2] [RFC] tracing: Showing symbols for TRACE_EVENT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic,

Is this what you were thinking about?

Peter,

This now tightly couples the enum with the trace export.
It also allows you to couple it with the current __print_symbolic()

Careful, I may start getting CPP happy again.

-- Steve



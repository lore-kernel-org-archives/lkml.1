Return-Path: <linux-kernel-owner+w=401wt.eu-S1751094AbZHLVKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751094AbZHLVKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbZHLVKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:10:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:56776 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZHLVKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:10:16 -0400
Subject: Re: [RFD] Kprobes/Kretprobes perf support
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>
In-Reply-To: <20090812191305.GB5974@nowhere>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
	 <4A82EEC5.8000603@redhat.com> <4A82F5A0.2090603@redhat.com>
	 <20090812191305.GB5974@nowhere>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 23:09:57 +0200
Message-Id: <1250111397.7035.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 21:13 +0200, Frederic Weisbecker wrote:

> Ingo, Peter do you have an idea on how we could do that?

Wouldn't it be easiest to use ftrace to create dynamic tracepoints in
the ftrace way such that they become available in
debugfs://tracing/events/kprobes/*/ and then have them interfaced the
same way as all other tracepoints?




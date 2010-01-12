Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191Ab0ALTMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab0ALTMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 14:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549Ab0ALTMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 14:12:50 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:16641 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab0ALTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:12:49 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zz1432R98dNzz1202hz4fhzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B4CC992.3010707@am.sony.com>
Date: Tue, 12 Jan 2010 11:12:18 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>	 <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>	 <20100112045454.GJ5243@nowhere> <1263272933.28171.3804.camel@gandalf.stny.rr.com>
In-Reply-To: <1263272933.28171.3804.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jan 2010 19:12:20.0157 (UTC) FILETIME=[29B7F6D0:01CA93BB]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> I do this all the time to limit the function tracer to a specific app.
> 
> #!/bin/sh
> echo $$ > /debug/tracing/set_ftrace_pid
> echo function > /debug/tracing/current_tracer
> exec $*

This seems pretty handy.  You should put this in scripts/tracing.
:-)

Do you have any other helper scripts you use commonly?
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================


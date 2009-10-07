Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbZJGPQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbZJGPQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZJGPQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:16:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41547 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZJGPQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:16:21 -0400
Subject: Re: system gets stuck in a lock during boot
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, Justin Mattock <justinmattock@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091007150506.GB8508@Krystal>
References: <20090826073351.GE23435@elte.hu> <4A9549E5.5020002@gmail.com>
	 <dd18b0c30909071449q6834e847yb0f27ec971c9564a@mail.gmail.com>
	 <20091002211211.GA2633@redhat.com>
	 <1254792249.13160.213.camel@gandalf.stny.rr.com>
	 <20091006203225.GC2631@redhat.com>
	 <1254880921.1696.112.camel@gandalf.stny.rr.com>
	 <20091007143023.GA2659@redhat.com> <20091007144058.GB6110@Krystal>
	 <1254927329.1696.150.camel@gandalf.stny.rr.com>
	 <20091007150506.GB8508@Krystal>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 07 Oct 2009 11:14:23 -0400
Message-Id: <1254928463.1696.168.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 11:05 -0400, Mathieu Desnoyers wrote:


> Also adding a BUILD_BUG_ON() that checks the structure sizeof() would be
> a nice safety-net (this should probably be added to tracepoints too
> eventually).

Yeah, I was thinking the same thing. But that would have to be added
somewhere in a C file.

-- Steve



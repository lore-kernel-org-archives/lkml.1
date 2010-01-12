Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708Ab0ALWBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0ALWBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 17:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712Ab0ALWBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 17:01:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0ALWBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 17:01:09 -0500
Message-ID: <4B4CF0F4.3020706@redhat.com>
Date: Tue, 12 Jan 2010 17:00:20 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Maneesh Soni <maneesh@in.ibm.com>,
       Mark Wielaard <mjw@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>	<20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>	<20100112045454.GJ5243@nowhere> <y0mhbqr40ja.fsf@fche.csb>
In-Reply-To: <y0mhbqr40ja.fsf@fche.csb>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Ch. Eigler wrote:
> 
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
>> [...]
>> This is much more tricky in the case of uprobes as I see two
>> ways to work with it:
>> - probing on an already running process
>> - probing on a process we are about to run
>> [...]
> 
> As you might expect, in systemtap we've had to figure out this area
> some time ago.  We use another utrace consumer called "task finder"
> that registers interest in present / future processes, and gives us
> kernel-space callbacks when these come and go.  You could merge it or
> something like it.

So, could you tell us how the task-finder works and is implemented?
I think we'd better clarify what functions are required for uprobes
and pmu, and I think we may be able to re-implement improved pmu
on utrace.

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


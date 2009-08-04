Return-Path: <linux-kernel-owner+w=401wt.eu-S932093AbZHDOGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbZHDOGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZHDOGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:06:23 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:46123 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbZHDOGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:06:22 -0400
Message-ID: <4A784056.1020400@parrot.com>
Date: Tue, 4 Aug 2009 16:06:14 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: Tracing thread name
References: <4A76E42D.7010908@parrot.com> <20090803134843.GB23455@Krystal> <4A78099B.4@parrot.com> <20090804130510.GA23396@Krystal>
In-Reply-To: <20090804130510.GA23396@Krystal>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mathieu Desnoyers a écrit :
> * Matthieu CASTET (matthieu.castet@parrot.com) wrote:
>> Hi Mathieu,
>>
>> Mathieu Desnoyers a écrit :
>> Do you know if it is possible to patch my version to add such feature ?
>>
>> I saw that the name already change in the trace before/after an exec.
>> How lltv get the new name ?
>> With "fs.exec" tracepoint ?
>> In that case I could fake a "fs.exec" tracepoint in set_task_comm.
> 
> A better solution : you add a new event in both lttng and lttv, and
> modify state.c to support your new event. The current event to brand
> thread is named "userspace.thread_brand". Look for this in LTTV to see
> all the sites that need to support the new event (there are very few).
> 
Thanks, but I want to avoid to modify too much ltt (I use an old version
for 2.6.27 and my modifications may be useless for upstream).

I added "trace_fs_exec(tsk->comm);" at the end of set_task_comm and now
the thread got the correct name :)


Matthieu

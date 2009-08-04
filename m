Return-Path: <linux-kernel-owner+w=401wt.eu-S932776AbZHDKMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776AbZHDKMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932742AbZHDKMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:12:51 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:49036 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718AbZHDKMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:12:51 -0400
Message-ID: <4A78099B.4@parrot.com>
Date: Tue, 4 Aug 2009 12:12:43 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: Tracing thread name
References: <4A76E42D.7010908@parrot.com> <20090803134843.GB23455@Krystal>
In-Reply-To: <20090803134843.GB23455@Krystal>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Mathieu Desnoyers a écrit :
> * Matthieu CASTET (matthieu.castet@parrot.com) wrote:
>> Hi,
>>
>> I use ltt on a 2.6.27 on an arm architecture.
>> It works quite well, but I have a minor problem :
>>
>> my application sets thread name with prctl PR_SET_NAME. But ltt viewer
>> doesn't seem to saw it.
>>
> 
> Hrm, I guess we might want to instrument set_task_comm as you propose to
> get the correct process name, but if this gets us the thread name, I
> think it's only an implementation side-effect:

> The way LTTng handles thread names is by adding a userspace "thread
> branding" event. It should be executed at thread startup. The downside
> of the current LTTng approach is that we cannot know the name of threads
> already executing before we started tracing.
> 

Do you know if it is possible to patch my version to add such feature ?

I saw that the name already change in the trace before/after an exec.
How lltv get the new name ?
With "fs.exec" tracepoint ?
In that case I could fake a "fs.exec" tracepoint in set_task_comm.

Thanks

Matthieu

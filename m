Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYK0Pv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYK0Pv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYK0PvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:51:11 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:34382 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYK0PvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:51:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QLn4j43dyqOhrHzQO3CrKzcIOzwYu1RXDhrZcvi6d7/Fx7oCCBOuQdvqZGUqCFI6Y1
         fPQBGSD6rb/ES5p1QOyLny71+h7qhvuwP6+Saj9ce1xF+hUEjTWaFphvwpg5XoIELysf
         /kV+bF7A/mfMVvUpXwZWcBYgmW9JYdwU8ufGU=
Message-ID: <c62985530811270751o3593e409ia35d7060120fbc90@mail.gmail.com>
Date: Thu, 27 Nov 2008 16:51:06 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the trace output
Cc: "Ingo Molnar" <mingo@elte.hu>, "Tim Bird" <tim.bird@am.sony.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <alpine.DEB.1.10.0811271028260.18691@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492DEDE9.9010109@gmail.com> <20081127103424.GA9132@elte.hu>
	 <c62985530811270506o51195654y628f8ab68ff68ac7@mail.gmail.com>
	 <20081127135155.GA23076@elte.hu>
	 <c62985530811270644r2de621ecwfdeb1d353197bdae@mail.gmail.com>
	 <alpine.DEB.1.10.0811271028260.18691@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/27 Steven Rostedt <rostedt@goodmis.org>:
> No, please keep the CPU # first.  If anything, you will want to separate
> out the CPUs first. Otherwise you will see things all mixed up.


So perhaps between CPU and time?
I don't really like it after the time, not so easy to find....

> Hmm, I could also add a per cpu files.
>
>  debugfs/tracing/buffers/cpu0
>  debugfs/tracing/buffers/cpu1
>  debugfs/tracing/buffers/cpu2
>  debugfs/tracing/buffers/cpu3


That would be useful indeed, as the ftrace_trace_pid on this tracer.
But I wonder about the cost of double function tracing in this case.
Your idea of a tgid;pid would be nice (with tgid || pid).


> That would print out the trace for a single CPU.
>
> BTW, I'm really not here. I'm on holiday eating turkeys.

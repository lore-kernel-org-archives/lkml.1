Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZKTIUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZKTIUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbZKTIUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:20:17 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42156 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbZKTIUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:20:16 -0500
Message-ID: <4B065145.2000709@cs.helsinki.fi>
Date: Fri, 20 Nov 2009 10:20:21 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] tracing: Remove kmemtrace tracer
References: <4B064AF5.9060208@cn.fujitsu.com> <4B064B0B.30207@cn.fujitsu.com>
In-Reply-To: <4B064B0B.30207@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan kirjoitti:
> The kmem trace events can replace the functions of kmemtrace
> tracer.
> 
> And kmemtrace-user can be modified to use trace events.
> (But after cloning the git repo, I found it's still based on
> the original relay version..), not to mention now we have
> 'perf kmem' tool.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

NAK for the time being. "perf kmem" output is not yet as good as that of 
kmemtrace-user.

			Pekka

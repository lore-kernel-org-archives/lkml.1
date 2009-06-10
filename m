Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbZFJBfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbZFJBfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZFJBfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:35:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57613 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbZFJBfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:35:07 -0400
Message-ID: <4A2F0E26.9010203@cn.fujitsu.com>
Date: Wed, 10 Jun 2009 09:36:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing/events/ring-buffer: block trace
 points and fix
References: <20090609163657.557589106@goodmis.org> <20090609234655.GA24118@elte.hu> <4A2F0C4A.8020109@cn.fujitsu.com> <alpine.DEB.2.00.0906092131190.30552@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0906092131190.30552@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> In file included from mm/highmem.c:30:
>>> include/linux/blktrace_api.h:223: warning: ?struct request? declared inside parameter list
>>> include/linux/blktrace_api.h:223: warning: its scope is only this definition or declaration, which is probably not what you want
>>> include/linux/blktrace_api.h: In function ?blk_cmd_buf_len?:
>>> include/linux/blktrace_api.h:225: error: implicit declaration of function ?blk_pc_request?
>>> include/linux/blktrace_api.h:225: error: dereferencing pointer to incomplete type
>>> include/linux/blktrace_api.h: At top level:
>>> include/linux/blktrace_api.h:228: warning: ?struct request? declared inside parameter list
>>> include/linux/blktrace_api.h:230: warning: ?struct request? declared inside parameter list
>>> distcc[15629] ERROR: compile mm/highmem.c on a/32 failed
>>>
>> I've fixed it. I'll post a new version after I've done some
>> more building tests.
> 
> Ingo,
> 
> Should Li post a delta fix, or should we just rebase?
> 

I thought we should rebase it, since it causes building failure which
might hurt bisectability.


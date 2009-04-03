Return-Path: <linux-kernel-owner+w=401wt.eu-S936086AbZDCTv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936086AbZDCTv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 15:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934141AbZDCTuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 15:50:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41771 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935030AbZDCTun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 15:50:43 -0400
Date: Fri, 3 Apr 2009 15:50:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ftrace: Add check of sched_stopped for
 probe_sched_wakeup
In-Reply-To: <49D1C543.3010307@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0904031550250.21481@gandalf.stny.rr.com>
References: <49D1C51C.7000407@cn.fujitsu.com> <49D1C543.3010307@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 31 Mar 2009, Zhaolei wrote:

> We need check sched_stopped in probe_sched_wakeup() to stop tracing when an
> user stops it.
> 
> But current code can also do the right thing(stop tracing after
> echo 0 > tracing_enabled) just because tracing_sched_wakeup_trace() can return
> on buffer->record_disabled.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Thanks, applied.

-- Steve


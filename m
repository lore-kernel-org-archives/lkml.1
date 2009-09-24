Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbZIXAWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbZIXAWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZIXAWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:22:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57743 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbZIXAWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:22:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] tracing/workqueue: Rename workqueue_execute to worklet_entry and add worklet_exit
Cc: kosaki.motohiro@jp.fujitsu.com, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090922203414.GA5059@nowhere>
References: <20090922024232.GC31801@kryten> <20090922203414.GA5059@nowhere>
Message-Id: <20090924092023.B645.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 24 Sep 2009 09:22:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> In Kosaki's patch, we had the work struct address displayed too.
> Your version is supposed to be sufficient because we know a workqueue
> serializes its works. Then we know that an exit event will always follow
> and match the previous entry event from the same workqueue thread.
> The workqueue pid then provides a sufficient key for that.
> 
> That said, we should worry about possible lost events from
> perf in some circumstances. And userspace profiling needs something
> to ensure the accuracy about this entry/exit pair.
> 
> We could have:
> 	entry work1
> 	exit work 1 <--- lost event
> 	entry work2 <--- lost event
> 	exit work2
> 
> And then the pair would be misinterpreted.
> 
> (Although we could have even other misinterpretation
> with other kind of scenarios, even if we have this work
> address. But that's still more safety).
> 
> So I'd prefer to keep Kosaki's idea about these keys.
> But I prefer your event naming.
> 
> May be I can unearth Kosaki's patch, change it with your naming
> and add your Signed-off-by?
> 
> Kosaki, no problem about it?

Sure.
Thank you paid attention my patch :-)






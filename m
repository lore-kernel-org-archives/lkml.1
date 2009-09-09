Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbZIIDBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbZIIDBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZIIDBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:01:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35127 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZIIDBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:01:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] tracing: Add sysctl to enable/disable tracing on oops
Cc: kosaki.motohiro@jp.fujitsu.com, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AA715A3.8040108@cn.fujitsu.com>
References: <20090909113231.0CE6.A69D9226@jp.fujitsu.com> <4AA715A3.8040108@cn.fujitsu.com>
Message-Id: <20090909115233.0CEC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  9 Sep 2009 12:01:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I have another silly question.
> > Why should we call tracing_off() in oops_enter()?
> 
> I guess it's because trace outputs generated during oops can
> overwrite/mess up those generated before oops?
> 
> It was added by this commit, but I can't find trace_printk_on_oops.

Ah, thanks.
I guess trace_printk_on_oops mean ftrace_dump_on_oops.





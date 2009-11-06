Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbZKFBer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbZKFBer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 20:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZKFBeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 20:34:46 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:57962 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbZKFBeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 20:34:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqkEABIM80pGGN1W/2dsb2JhbACBT943hD0E
Date: Thu, 5 Nov 2009 20:29:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, zhaolei@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] softirq,tracing: enable to trace softirq raise latency
Message-ID: <20091106012949.GG24590@Krystal>
References: <4AF284CF.3010407@cn.fujitsu.com> <20091105144349.GA8317@Krystal> <4AF3789F.8070904@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4AF3789F.8070904@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:29:04 up 79 days, 12:18,  2 users,  load average: 0.30, 0.23,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> Mathieu Desnoyers wrote:
> > * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> >> +/**
> >>   * softirq_entry - called immediately before the softirq handler
> >>   * @h: pointer to struct softirq_action
> >>   * @vec: pointer to first struct softirq_action in softirq_vec array
> > 
> > Please change this comment to "@vec: softirq vector number" while you
> > are at it. The same probably needs to be done for softirq_exit. @vec are
> > not pointers: these are offsets.
> > 
> 
> Thank you for you like it and your comment.
> 
> @vec are pointers here. it's softirq_vec. Don't need to change
> these comments.

Ah, yes, you're right. I got confused by looking only at the patch
context.

Thanks,

Mathieu

> 
> Lai

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

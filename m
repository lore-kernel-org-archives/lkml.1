Return-Path: <linux-kernel-owner+w=401wt.eu-S1763647AbZE0OXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763647AbZE0OXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760229AbZE0OXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:23:10 -0400
Received: from www.tglx.de ([62.245.132.106]:51361 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099AbZE0OXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:23:09 -0400
Date: Wed, 27 May 2009 16:22:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Anton Blanchard <anton@samba.org>, rostedt@goodmis.org, mingo@elte.hu,
       tzanussi@gmail.com, jbaron@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/events: Add timer and high res timer
 tracepoints
In-Reply-To: <4A1D07C8.6010002@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0905271619360.3397@localhost.localdomain>
References: <20090520101334.GA23442@kryten> <20090526042643.GB19728@kryten> <20090526180600.GA5969@nowhere> <4A1D07C8.6010002@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Xiao Guangrong wrote:
> In fact, Anton Blanchard's is different from my patch.
> My patch is used for trace timer lifecycle(init/start/expire/cancel), and his
> patch is mostly used for trace the execution time of timer function.

Right, but they should be combined into one set.

Frederic, can you please pick up Anton's patch right away so Xiao can
work on top of it and add the init/start/cancel instrumentation.

Thanks,

	tglx

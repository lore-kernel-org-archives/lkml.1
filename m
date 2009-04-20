Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbZDTAgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbZDTAgn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 20:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZDTAge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 20:36:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59390 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbZDTAgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 20:36:33 -0400
Message-ID: <49EBC3BF.50404@cn.fujitsu.com>
Date: Mon, 20 Apr 2009 08:37:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracing/core: Add current context on tracing recursion
 warning
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <49EAC15E.7080702@cn.fujitsu.com> <20090419123430.GA5967@nowhere> <20090419134927.GA6262@nowhere> <20090419172837.GA5992@nowhere>
In-Reply-To: <20090419172837.GA5992@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now I can reproduce it. It seems to happen when I set a filter,

Right, you said filter seems to be broken, so I tried to set a filter
and enabled the trace event, and got this warning.

> but also on other situations:
> 
> Bisected back to:
> 
> commit 261842b7c9099f56de2eb969c8ad65402d68e00e
> tracing: add same level recursion detection
> 
> It might be caused by a bug in this patch or
> by real tracing recursions on some places.

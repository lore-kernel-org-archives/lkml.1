Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZKTR7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZKTR7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZKTR7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:59:03 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59093 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbZKTR7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:59:01 -0500
X-Greylist: delayed 2212 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 12:58:46 EST
Date: Fri, 20 Nov 2009 17:22:53 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: rostedt@goodmis.org, Nicholas Mc Guire <der.herr@hofr.at>,
       zhangfx@lemote.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH v9 02/10] tracing: enable
	HAVE_FUNCTION_TRACE_MCOUNT_TEST for MIPS
Message-ID: <20091120172253.GC6869@linux-mips.org>
References: <cover.1258719323.git.wuzhangjin@gmail.com> <51e30436a435480f1f0dec146a82f2b250900690.1258719323.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51e30436a435480f1f0dec146a82f2b250900690.1258719323.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 08:34:30PM +0800, Wu Zhangjin wrote:

> There is an exisiting common ftrace_test_stop_func() in
> kernel/trace/ftrace.c, which is used to check the global variable
> ftrace_trace_stop to determine whether stop the function tracing.
> 
> This patch implepment the MIPS specific one to speedup the procedure.
> 
> Thanks goes to Zhang Le for Cleaning it up.
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

Queued for 2.6.33 but due to patch 3/3 I won't propagate this series
immediately to linux-next.

Thanks!

  Ralf

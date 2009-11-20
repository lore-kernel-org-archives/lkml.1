Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbZKTR7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbZKTR7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZKTR7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:59:07 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59093 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbZKTR7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:59:05 -0500
X-Greylist: delayed 2212 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 12:58:46 EST
Date: Fri, 20 Nov 2009 17:24:38 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: rostedt@goodmis.org, Nicholas Mc Guire <der.herr@hofr.at>,
       zhangfx@lemote.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH v9 07/10] tracing: add dynamic function graph tracer
	for MIPS
Message-ID: <20091120172438.GG6869@linux-mips.org>
References: <cover.1258719323.git.wuzhangjin@gmail.com> <c08257b0ef370f6e04ff9719bf7499bae28c70f4.1258719323.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c08257b0ef370f6e04ff9719bf7499bae28c70f4.1258719323.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 08:34:35PM +0800, Wu Zhangjin wrote:

> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> This patch make function graph tracer work with dynamic function tracer.
> 
> To share the source code of dynamic function tracer(MCOUNT_SAVE_REGS),
> and avoid restoring the whole saved registers, we need to restore the ra
> register from the stack.
> 
> (NOTE: This not work with 32bit! need to ensure why!)
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

Queued for 2.6.33 but due to patch 3/3 I won't propagate this series
immediately to linux-next.

Thanks!

  Ralf

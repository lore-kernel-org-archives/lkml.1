Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZKTR7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZKTR7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbZKTR7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:59:17 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59093 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbZKTR7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:59:13 -0500
X-Greylist: delayed 2212 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 12:58:46 EST
Date: Fri, 20 Nov 2009 17:25:17 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: rostedt@goodmis.org, Nicholas Mc Guire <der.herr@hofr.at>,
       zhangfx@lemote.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH v9 09/10] tracing: reserve $12(t0) for
	mcount-ra-address of gcc 4.5
Message-ID: <20091120172517.GI6869@linux-mips.org>
References: <cover.1258719323.git.wuzhangjin@gmail.com> <76ddc2b8164e0e2f239ddd81ef1ef6a241540004.1258719323.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76ddc2b8164e0e2f239ddd81ef1ef6a241540004.1258719323.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 08:34:37PM +0800, Wu Zhangjin wrote:

> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> A new option -mmcount-ra-address for gcc 4.5 have been sent by David
> Daney <ddaney@caviumnetworks.com> in the thread "MIPS: Add option to
> pass return address location to _mcount", which help to record the
> location of the return address(ra) for the function graph tracer of MIPS
> to hijack the return address easier and safer. that option used the
> $12(t0) register by default, so, we reserve it for it, and use t1,t2,t3
> instead of t0,t1,t2.
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

Queued for 2.6.33 but due to patch 3/3 I won't propagate this series
immediately to linux-next.

Thanks!

  Ralf

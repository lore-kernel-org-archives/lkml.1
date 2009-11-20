Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbZKTR7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbZKTR7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbZKTR7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:59:44 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59093 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbZKTR7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:59:43 -0500
X-Greylist: delayed 2212 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 12:58:46 EST
Date: Fri, 20 Nov 2009 17:20:39 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: rostedt@goodmis.org, Nicholas Mc Guire <der.herr@hofr.at>,
       zhangfx@lemote.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Wu Zhangjin <wuzj@lemote.com>
Subject: Re: [PATCH v9 03/10] tracing: add an endian argument to
	scripts/recordmcount.pl
Message-ID: <20091120172039.GA6869@linux-mips.org>
References: <cover.1258719323.git.wuzhangjin@gmail.com> <267c0824194b659b46fc038ba43492df30369fec.1258719323.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <267c0824194b659b46fc038ba43492df30369fec.1258719323.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 08:34:31PM +0800, Wu Zhangjin wrote:

> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> MIPS and some other architectures need this argument to handle
> big/little endian respectively.
> 
> Signed-off-by: Wu Zhangjin <wuzj@lemote.com>

This one is a bit problematic because you seem to have generated the
patch against linux-next but I'm applying it on the MIPS -queue tree and
some other changes on -next are now resulting in a conflict.  And
Steven Rostedt is going to merge a few more changes which he says will
conflict.

So I put this patch on the queue tree but may not propagate it immediately
to linux-next.

Thanks!

  Ralf

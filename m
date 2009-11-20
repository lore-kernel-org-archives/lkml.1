Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZKTR6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZKTR6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZKTR6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:58:53 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59093 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbZKTR6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:58:51 -0500
X-Greylist: delayed 2212 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 12:58:46 EST
Date: Fri, 20 Nov 2009 17:24:57 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: rostedt@goodmis.org, Nicholas Mc Guire <der.herr@hofr.at>,
       zhangfx@lemote.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH v9 08/10] tracing: make ftrace for MIPS work without
	-fno-omit-frame-pointer
Message-ID: <20091120172457.GH6869@linux-mips.org>
References: <cover.1258719323.git.wuzhangjin@gmail.com> <16e57c64d806acc5fc3440370aa0ff97a5db7dc3.1258719323.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16e57c64d806acc5fc3440370aa0ff97a5db7dc3.1258719323.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 08:34:36PM +0800, Wu Zhangjin wrote:

> When remove the -fno-omit-frame-pointer, gcc will not save the frame
> pointer for us, we need to save one ourselves.
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

Queued for 2.6.33 but due to patch 3/3 I won't propagate this series
immediately to linux-next.

Thanks!

  Ralf

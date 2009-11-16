Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZKPOT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZKPOT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZKPOTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:19:54 -0500
Received: from www.tglx.de ([62.245.132.106]:44778 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbZKPOTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:19:53 -0500
Date: Mon, 16 Nov 2009 15:19:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ralf Baechle <ralf@linux-mips.org>
cc: Wu Zhangjin <wuzhangjin@gmail.com>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Michal Simek <monstr@monstr.eu>,
       "Maciej W . Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com
Subject: Re: [PATCH v8 00/16] ftrace for MIPS
In-Reply-To: <20091116134831.GA10189@linux-mips.org>
Message-ID: <alpine.LFD.2.00.0911161506540.24119@localhost.localdomain>
References: <cover.1258177321.git.wuzhangjin@gmail.com> <20091116134831.GA10189@linux-mips.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009, Ralf Baechle wrote:
> On Sat, Nov 14, 2009 at 02:30:31PM +0800, Wu Zhangjin wrote:
> 
> Time to talk about how to get the whole thing merged.
> 
> I'm reasonably happy with the arch part of the patchset.  There are two
> remaining issues in the arch part - cache flushing will not work as is on
> a SMP system and the whole code patching is going to fail if the kernel
> text is replicated with CONFIG_REPLICATE_KTEXT which is an IP27-only option.
> 
> I suggest we should go ahready and just disallow dynamic ftrace on on
> these problematic configurations for now and deal with them later, so
> something like
> 
> 	select HAVE_DYNAMIC_FTRACE if !SMP && !REPLICATE_KTEXT

Makes sense.
 
> This leaves the non-arch bits to merge; patches which touch code outside
> of arch/mips are:

I'm going to comment on the patches.

Thanks,

	tglx

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbXDGIsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbXDGIsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965606AbXDGIsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:48:21 -0400
Received: from www.osadl.org ([213.239.205.134]:43042 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752204AbXDGIsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:48:20 -0400
Subject: Re: [patch] high-res timers: UP resume fix
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <20070407082554.GA1943@elte.hu>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
	 <1175899460.5393.9.camel@localhost>
	 <Pine.LNX.4.64.0704061552380.6730@woody.linux-foundation.org>
	 <20070407081244.GA28284@elte.hu>  <20070407082554.GA1943@elte.hu>
Content-Type: text/plain
Date: Sat, 07 Apr 2007 10:48:49 +0200
Message-Id: <1175935730.28263.510.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-07 at 10:25 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > [...] Soeren, can you confirm that you are using a !CONFIG_SMP kernel, 
> > and if yes, does the patch below fix the resume problem for you?
> 
> hm, you seem to have a CONFIG_SMP=y kernel. I dont immediately see where 
> we re-enable interrupts in the SMP case, but could you try my patch 
> nevertheless

We do in on_each_cpu() unconditionally. I missed that.

	tglx



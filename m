Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbZEKJ2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbZEKJ2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbZEKJ2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:28:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbZEKJ2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:28:43 -0400
Date: Mon, 11 May 2009 05:28:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH -tip v5 5/7] x86: fix kernel_trap_sp()
Message-ID: <20090511092841.GB23875@infradead.org>
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004904.5505.59034.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509004904.5505.59034.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 08:49:04PM -0400, Masami Hiramatsu wrote:
> Use &regs->sp instead of regs for getting the top of stack in kernel mode.
> (on x86-64, regs->sp always points the top of stack)

Shouldn't this patch be sent for inclusion ASAP instead of sitting in
this series?


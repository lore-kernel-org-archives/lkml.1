Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZEKNrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZEKNrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZEKNra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:47:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39623 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbZEKNr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:47:29 -0400
Message-ID: <4A082CC4.5000601@redhat.com>
Date: Mon, 11 May 2009 09:48:52 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH -tip v5 5/7] x86: fix kernel_trap_sp()
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004904.5505.59034.stgit@localhost.localdomain> <20090511092841.GB23875@infradead.org>
In-Reply-To: <20090511092841.GB23875@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, May 08, 2009 at 08:49:04PM -0400, Masami Hiramatsu wrote:
>> Use &regs->sp instead of regs for getting the top of stack in kernel mode.
>> (on x86-64, regs->sp always points the top of stack)
> 
> Shouldn't this patch be sent for inclusion ASAP instead of sitting in
> this series?

Yes, and it's just for asking a comment from oprofile developers,
because this change will change its behavior a bit.

Anyway, I'll post it separately against upstream.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0BJDQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:16:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab0BJDQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:16:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
From: Roland McGrath <roland@redhat.com>
To: "H.J. Lu" <hjl.tools@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch v2 4/4] ptrace: Add support for generic 
	PTRACE_GETREGSET/PTRACE_SETREGSET
In-Reply-To: H.J. Lu's message of  Tuesday, 9 February 2010 18:03:33 -0800 <6dc9ffc81002091803o5f5cc632sfd7fad0b41545a97@mail.gmail.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
	<20100209202502.406177090@sbs-t61.sc.intel.com>
	<20100210015257.942463E8@magilla.sf.frob.com>
	<6dc9ffc81002091803o5f5cc632sfd7fad0b41545a97@mail.gmail.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20100210030737.E99A573D8@magilla.sf.frob.com>
Date: Tue,  9 Feb 2010 19:07:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There is no need for a global function for this.  It should all be static
> > in kernel/ptrace.c, called only by ptrace_request()/compat_ptrace_request().
> >
> 
> Won't it be called by ptrace emulation in utrace?

I guess I don't really understand the question.  I'm not aware of any
patches where any such things are done anywhere except the existing
ptrace_request and compat_ptrace_request functions in kernel/ptrace.c.


Thanks,
Roland

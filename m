Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0BPObO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 09:31:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32799 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803Ab0BPObN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 09:31:13 -0500
Date: Tue, 16 Feb 2010 15:30:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, gorcunov@gmail.com,
       aris@redhat.com
Subject: Re: [PATCH 1/4] nmi_watchdog: use a boolean config flag for compiling
Message-ID: <20100216143052.GB10917@elte.hu>
References: <1266013161-31197-1-git-send-email-dzickus@redhat.com>
 <20100214165941.GA26329@elte.hu>
 <20100215175106.GM3062@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215175106.GM3062@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Sun, Feb 14, 2010 at 05:59:41PM +0100, Ingo Molnar wrote:
> > 
> > i'm still getting build failures:
> > 
> > arch/x86/built-in.o: In function `arch_trigger_all_cpu_backtrace':
> > (.text+0x151f5): undefined reference to `apic'
> > 
> > config attached.
> 
> Hmm, I can't get the config to match up properly when I run 'make 
> oldconfig', even though I am using the HEAD of perf/nmi.  I took the 
> defaults anyway and used 'ARCH=i386 make all' but couldn't reproduce your 
> build failure.

Hm, neither can i reproduce it with the config i sent. Maybe i sent the wrong 
config, or it somehow got solved meanwhile. I'll re-add perf/nmi to 
tip:master and we'll see it shortly whether there are any build failures 
left.

Thanks,

	Ingo

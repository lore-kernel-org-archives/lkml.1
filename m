Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0BORwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 12:52:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab0BORwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 12:52:44 -0500
Date: Mon, 15 Feb 2010 12:51:06 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, gorcunov@gmail.com,
       aris@redhat.com
Subject: Re: [PATCH 1/4] nmi_watchdog: use a boolean config flag for compiling
Message-ID: <20100215175106.GM3062@redhat.com>
References: <1266013161-31197-1-git-send-email-dzickus@redhat.com>
 <20100214165941.GA26329@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100214165941.GA26329@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 05:59:41PM +0100, Ingo Molnar wrote:
> 
> i'm still getting build failures:
> 
> arch/x86/built-in.o: In function `arch_trigger_all_cpu_backtrace':
> (.text+0x151f5): undefined reference to `apic'
> 
> config attached.

Hmm, I can't get the config to match up properly when I run 'make
oldconfig', even though I am using the HEAD of perf/nmi.  I took the
defaults anyway and used 'ARCH=i386 make all' but couldn't reproduce your
build failure.

Looking through the code, is there ever case where 'apic' is undefined?
The arch_trigger_all_cpu_backtrace should match identically to the old nmi
code, so I am stuck on how to fix this.

Thoughts?

Cheers,
Don

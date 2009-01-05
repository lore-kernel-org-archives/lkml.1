Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZAETx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZAETx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbZAETxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:53:46 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:55108 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbZAETxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:53:45 -0500
Date: Mon, 5 Jan 2009 20:55:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jan Beulich <jbeulich@novell.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org,
       "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: Re: ftrace breaks sparc64 build
Message-ID: <20090105195523.GB6204@uranus.ravnborg.org>
References: <20090105181922.GA25622@uranus.ravnborg.org> <20090105194844.GR28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105194844.GR28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Jan.

And yes - I see the same but with a slightly different error message.

	Sam

On Mon, Jan 05, 2009 at 07:48:44PM +0000, Al Viro wrote:
> On Mon, Jan 05, 2009 at 07:19:22PM +0100, Sam Ravnborg wrote:
> > With an allmodconfig build on sparc and sparc64 I started
> > to see warnings that become propagated to errors by -Werror.
> 
> While we are at it, sparc32 allmodconfig is broken by
> commit 9bb482476c6c9d1ae033306440c51ceac93ea80c
> Author: Jan Beulich <jbeulich@novell.com>
> Date:   Tue Dec 16 11:30:08 2008 +0000
> 
>     allow stripping of generated symbols under CONFIG_KALLSYMS_ALL
> 
> Results in
> sparc-linux-objcopy: not stripping symbol `__ksymtab_strings' because it is named in a relocation
> sparc-linux-objcopy: not stripping symbol `__crc_per_cpu__softirq_work_list' because it is named in a relocation
> sparc-linux-objcopy: not stripping symbol `__initcall_end' because it is named in a relocation
> sparc-linux-objcopy: not stripping symbol `__setup_end' because it is named in a relocation
> sparc-linux-objcopy: not stripping symbol `__setup_start' because it is named in a relocation
> sparc-linux-objcopy: not stripping symbol `__initcall_start' because it is named in a relocation
> make: *** [.tmp_vmlinux1.stripped] Error 1

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbXKTNGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbXKTNGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 08:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757116AbXKTNF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 08:05:57 -0500
Received: from www.tglx.de ([62.245.132.106]:40927 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756612AbXKTNF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 08:05:56 -0500
Date: Tue, 20 Nov 2007 14:05:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] x86 vDSO: arch/x86/vdso/vdso32
In-Reply-To: <20071119220425.6002E26F8BE@magilla.localdomain>
Message-ID: <alpine.LFD.0.9999.0711201402520.25057@localhost.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain> <20071119220425.6002E26F8BE@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland,

On Mon, 19 Nov 2007, Roland McGrath wrote:

> 
> This moves the i386 vDSO sources into arch/x86/vdso/vdso32/, a
> new directory.  This patch is a pure renaming, but paves the way
> for consolidating the vDSO build logic.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  arch/x86/ia32/vsyscall-sigreturn.S                 |    3 +--
>  arch/x86/kernel/Makefile_32                        |    3 +++
>  .../vsyscall-int80_32.S => vdso/vdso32/int80.S}    |    2 +-
>  .../vsyscall-note_32.S => vdso/vdso32/note.S}      |    2 +-
>  .../vdso32/sigreturn.S}                            |    0 
>  .../vdso32/sysenter.S}                             |    2 +-
>  6 files changed, 7 insertions(+), 5 deletions(-)
>  rename arch/x86/{kernel/vsyscall-int80_32.S => vdso/vdso32/int80.S} (97%)
>  rename arch/x86/{kernel/vsyscall-note_32.S => vdso/vdso32/note.S} (95%)
>  rename arch/x86/{kernel/vsyscall-sigreturn_32.S => vdso/vdso32/sigreturn.S} (100%)
>  rename arch/x86/{kernel/vsyscall-sysenter_32.S => vdso/vdso32/sysenter.S} (99%)

I just stumbled accross those renames, when I tried to apply your
series from the mailbox. I guess there is some option to git which
creates a real patch. I fixed it up manually for now.

Thanks,

	tglx

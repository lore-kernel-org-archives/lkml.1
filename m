Return-Path: <linux-kernel-owner+w=401wt.eu-S1764234AbXKTU6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764234AbXKTU6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbXKTU6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:58:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757638AbXKTU6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:58:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] x86 vDSO: arch/x86/vdso/vdso32
In-Reply-To: Thomas Gleixner's message of  Tuesday, 20 November 2007 14:05:24 +0100 <alpine.LFD.0.9999.0711201402520.25057@localhost.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
	<20071119220425.6002E26F8BE@magilla.localdomain>
	<alpine.LFD.0.9999.0711201402520.25057@localhost.localdomain>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071120205759.3533A26F8BE@magilla.localdomain>
Date: Tue, 20 Nov 2007 12:57:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >  rename arch/x86/{kernel/vsyscall-int80_32.S => vdso/vdso32/int80.S} (97%)
> >  rename arch/x86/{kernel/vsyscall-note_32.S => vdso/vdso32/note.S} (95%)
> >  rename arch/x86/{kernel/vsyscall-sigreturn_32.S => vdso/vdso32/sigreturn.S} (100%)
> >  rename arch/x86/{kernel/vsyscall-sysenter_32.S => vdso/vdso32/sysenter.S} (99%)
> 
> I just stumbled accross those renames, when I tried to apply your
> series from the mailbox. I guess there is some option to git which
> creates a real patch. I fixed it up manually for now.

You don't have to do anything manual.  git-apply handles these fine.
>From my introduction post (00/18):

	There are several renames in here, so GIT can apply them but maybe patch
	can't.  (If there is a switch to git-format-patch to produce something
	more universally applicable, I haven't found it.)



Thanks,
Roland

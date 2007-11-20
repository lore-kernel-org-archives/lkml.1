Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbXKTXIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbXKTXIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbXKTXIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:08:06 -0500
Received: from www.tglx.de ([62.245.132.106]:54179 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198AbXKTXIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:08:04 -0500
Date: Wed, 21 Nov 2007 00:07:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] x86 vDSO: arch/x86/vdso/vdso32
In-Reply-To: <20071120205759.3533A26F8BE@magilla.localdomain>
Message-ID: <alpine.LFD.0.9999.0711202348470.25057@localhost.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain> <20071119220425.6002E26F8BE@magilla.localdomain> <alpine.LFD.0.9999.0711201402520.25057@localhost.localdomain> <20071120205759.3533A26F8BE@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Roland McGrath wrote:

> > >  rename arch/x86/{kernel/vsyscall-int80_32.S => vdso/vdso32/int80.S} (97%)
> > >  rename arch/x86/{kernel/vsyscall-note_32.S => vdso/vdso32/note.S} (95%)
> > >  rename arch/x86/{kernel/vsyscall-sigreturn_32.S => vdso/vdso32/sigreturn.S} (100%)
> > >  rename arch/x86/{kernel/vsyscall-sysenter_32.S => vdso/vdso32/sysenter.S} (99%)
> > 
> > I just stumbled accross those renames, when I tried to apply your
> > series from the mailbox. I guess there is some option to git which
> > creates a real patch. I fixed it up manually for now.
> 
> You don't have to do anything manual.  git-apply handles these fine.
> >From my introduction post (00/18):
> 
> 	There are several renames in here, so GIT can apply them but maybe patch
> 	can't.  (If there is a switch to git-format-patch to produce something
> 	more universally applicable, I haven't found it.)

Sorry my bad. I skipped that while reading through the series. git
rants are in my builtin "skip this section" regex patterns :)

I do not use git-apply of course.

git format-patch -p

does the trick at least here :)

     tglx




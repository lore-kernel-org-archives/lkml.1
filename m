Return-Path: <linux-kernel-owner+w=401wt.eu-S1763309AbXJZCrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763309AbXJZCrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758027AbXJZCq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:46:59 -0400
Received: from xenotime.net ([66.160.160.81]:57555 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757398AbXJZCq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:46:57 -0400
Date: Thu, 25 Oct 2007 19:46:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 5/6] x86: move i386 and x86_64 Kconfig files to x86
 directory
Message-Id: <20071025194653.46d39a13.rdunlap@xenotime.net>
In-Reply-To: <86802c440710251853w1b33ea66j13181664cb5a30a0@mail.gmail.com>
References: <20071025195644.GA14501@uranus.ravnborg.org>
	<20071025200546.GF14501@uranus.ravnborg.org>
	<86802c440710251853w1b33ea66j13181664cb5a30a0@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 18:53:18 -0700 Yinghai Lu wrote:

> On 10/25/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> > From 6654a98eb8587f0538904c9bdb9aeaf9d577f182 Mon Sep 17 00:00:00 2001
> > From: Sam Ravnborg <sam@ravnborg.org>
> > Date: Thu, 25 Oct 2007 21:04:16 +0200
> > Subject: [PATCH] x86: move i386 and x86_64 Kconfig files to x86 directory
> >
> > After a small change in kconfig Makefile we could
> > move all x86 Kconfig files to x86 directory.
> >
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > ---
> >  arch/{i386 => x86}/Kconfig.cpu              |    0
> >  arch/{i386 => x86}/Kconfig.debug            |    0
> >  arch/{i386/Kconfig => x86/Kconfig.i386}     |    4 +-
> >  arch/{x86_64/Kconfig => x86/Kconfig.x86_64} |    2 +-
> >  arch/x86_64/Kconfig.debug                   |  119 ---------------------------
> >  scripts/kconfig/Makefile                    |    7 ++-
> >  6 files changed, 9 insertions(+), 123 deletions(-)
> >  rename arch/{i386 => x86}/Kconfig.cpu (100%)
> >  rename arch/{i386 => x86}/Kconfig.debug (100%)
> >  rename arch/{i386/Kconfig => x86/Kconfig.i386} (99%)
> >  rename arch/{x86_64/Kconfig => x86/Kconfig.x86_64} (99%) <------<
> >  delete mode 100644 arch/x86_64/Kconfig.debug                    |
>                                                                    |
> arch/i386/Kconfig.debug will be arch/x86/Kconfig.debug             |
>                                                                    |
> in it, EARLY_PRINTK will depend on X86_32                          |
                                                                     |
but EARLY_PRINTK for x86_64 is here -------------------------------  ^

so we didn't lose it.  However, they should live in the same place
so that confusion like this does not continue.

You can make a patch.  or I can.  or Sam can.  or someone else can...

---
~Randy

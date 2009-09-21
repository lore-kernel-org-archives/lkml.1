Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZIUIFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZIUIFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 04:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZIUIFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 04:05:10 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:53362 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbZIUIFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 04:05:10 -0400
Date: Mon, 21 Sep 2009 10:05:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Tim Abbott <tabbott@ksplice.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH v3 4/4] Use macros for .data.page_aligned section.
Message-ID: <20090921080512.GA27736@merkur.ravnborg.org>
References: <1253472193-21106-1-git-send-email-tabbott@ksplice.com> <1253472193-21106-5-git-send-email-tabbott@ksplice.com> <20090921095717.6bd4e4e1@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921095717.6bd4e4e1@mschwide.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 09:57:17AM +0200, Martin Schwidefsky wrote:
> On Sun, 20 Sep 2009 14:43:13 -0400
> Tim Abbott <tabbott@ksplice.com> wrote:
> 
> > This patch changes the remaining direct references to
> > .data.page_aligned in C and assembly code to use the macros in
> > include/linux/linkage.h.
> > 
> > Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > ---
> >  arch/avr32/mm/init.c                        |    4 +---
> >  arch/powerpc/kernel/vdso.c                  |    3 ++-
> >  arch/powerpc/kernel/vdso32/vdso32_wrapper.S |    3 ++-
> >  arch/powerpc/kernel/vdso64/vdso64_wrapper.S |    3 ++-
> >  arch/s390/kernel/vdso.c                     |    2 +-
> >  arch/s390/kernel/vdso32/vdso32_wrapper.S    |    3 ++-
> >  arch/s390/kernel/vdso64/vdso64_wrapper.S    |    3 ++-
> >  arch/x86/include/asm/cache.h                |    4 +++-
> >  arch/x86/kernel/head_32.S                   |    2 +-
> >  9 files changed, 16 insertions(+), 11 deletions(-)
> 
> Compiles and works fine:
> Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Thanks for testing.
If I rebase I will add your ack.

	Sam

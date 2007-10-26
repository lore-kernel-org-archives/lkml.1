Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbXJZE2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbXJZE2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 00:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbXJZE1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 00:27:52 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34015 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbXJZE1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 00:27:51 -0400
Date: Fri, 26 Oct 2007 06:29:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 3/6] x86: unification of i386 and x86_64 Kconfig.debug
Message-ID: <20071026042926.GA18411@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org> <20071025200434.GD14501@uranus.ravnborg.org> <86802c440710251630j71b9f750j2e0fbe4c9b37165e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440710251630j71b9f750j2e0fbe4c9b37165e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 04:30:48PM -0700, Yinghai Lu wrote:
> >  config EARLY_PRINTK
> >         bool "Early printk" if EMBEDDED && DEBUG_KERNEL
> >         default y
> > +       depends on X86_32
> >         help
> >           Write kernel log output directly into the VGA buffer or to a serial
> >           port.
> ...
> 
> why disabling early_printk for x86_64?
The abovce disables the prompt but 
arch/x86_64/Kconifg.x86_64 set the value to y so EARLY_PRINTK is
always enabled (see answer I wrote to Kay).

This patchset leaves room for futher clean-up which is
welcome. The aim was to unify the two Kconfig.debug file
where Randy did a quick and good job. The aim was not
maximum unification of the Kconfig files used for the two
ARCH's this comes later - and there are much to be done
here.

Please let me know if you see other issues woth the patch serie.

	Sam

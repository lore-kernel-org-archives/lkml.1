Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbYDDVkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbYDDVkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYDDVkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:40:12 -0400
Received: from www.tglx.de ([62.245.132.106]:60636 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbYDDVkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:40:11 -0400
Date: Fri, 4 Apr 2008 23:39:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Garzik <jeff@garzik.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT pull] x86 fixes for 2.6.25
In-Reply-To: <47F69621.3080105@garzik.org>
Message-ID: <alpine.LFD.1.10.0804042339020.3224@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0804042019210.3224@apollo.tec.linutronix.de> <47F69621.3080105@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, Jeff Garzik wrote:
> Thomas Gleixner wrote:
> > 1) drivers/char/hpet.c
> >    include/linux/hpet.h
> > 
> >    due to the revert of the HPET irq assignemt, which was only affects x86.
> 
> 
> Related to this...  check out jgarzik/misc-2.6.git#irq-cleanups and
> #irq-remove for my set of patches that remove the 'irq' argument from all irq
> handlers.
> 
> I have a couple cleanup patches for HPET that should go in prior to the big
> "remove irq argument" massive change (even if people don't want to remove the
> 'irq' argument ultimately, the cleanup is still useful)
> 
> Who is the HPET maintainer these days, if anyone?

Dunno. It usually ends up in one of my git sinks :(

Thanks,
	tglx

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbXIFBDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbXIFBDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 21:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757218AbXIFBDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 21:03:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757149AbXIFBDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 21:03:15 -0400
Date: Wed, 5 Sep 2007 18:01:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Felix Homann <fexpop@onlinehome.de>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, ak@suse.de
Subject: Re: Regressions w.r.t. suspend behaviour in recent kernel versions
Message-Id: <20070905180143.b747f472.akpm@linux-foundation.org>
In-Reply-To: <46DF3306.7030608@onlinehome.de>
References: <46CED24F.1020400@onlinehome.de>
	<20070905093605.ac755ce6.akpm@linux-foundation.org>
	<46DF3306.7030608@onlinehome.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 06 Sep 2007 00:51:50 +0200 Felix Homann <fexpop@onlinehome.de> wrote:
> Andrew Morton wrote:
> >> On Fri, 24 Aug 2007 14:42:55 +0200 Felix Homann <fexpop@onlinehome.de> wrote:
> > 
> > Nearly two weeks, zero replies.
> 
> Thanks for caring :-)
> 
> > 
> >> Aug  9 00:22:13 jawaka kernel: EXT3-fs: mounted filesystem with ordered
> >> data mode.
> >> Aug  9 00:22:13 jawaka kernel: WARNING: at kernel/irq/resend.c:70
> >> check_irq_resend()
> > 
> > I expect that got fixed in later kernels.
> 
> Yes, I've just tried 2.6.23-rc5-git1 and the warning has gone!
> 
> 
> >> Without the nolapic option the kernel will panic when trying to suspend 
> >> to disk.
> > 
> > A *large* number of people need noapic or nolapic to get Linux to work.
> 
> Even better, on 2.6.23-rc5-git1 I don't need nolapic anymore!
> 

damn, we break so much stuff that now we're breaking our old bugs too!

> 
> >> Here are the last lines of the kernel output:
> >>
> >> EIP: [<c01127fd> lapic_nmi_suspend+0x1d/0x30 ss:ESP 0068:c1ae3ec8
> >> Kernel panic - not syncing: Attempted to kill init!
> > 
> > Are you able to provide us with more information about this bug? 
> 
> If you're still interested in more more information now that the bug has 
> apparently been solved "en passant" I can take a photograph tomorrow. 
> Please, let me know.

No thanks, let's just move on..

> >> With more recent kernels the system will hang with 
> >> "Suspending console(s)".
> > 
> > My Vaio reliably hangs at the same place with 2.6.23-rc4.  I'll bisect that
> > next week sometime.  Hopefully the result of that effort will fix your bug.
> >  Please test Linus's tree regularly and don't let us release 2.6.23 until
> > it is fixed.
> 
> Great!
> 
> 
> >> 3. Even with the 2.6.18 kernel sound won't work after suspending to ram. 
> >> I don't know when this started, but I know that this has not been an 
> >> issue in the past.
> > 
> > Please provide full details in a separate bug report.  Send that report to
> > myself, linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz> and
> > Takashi Iwai <tiwai@suse.de>
> 
> I'll do that in the next couple of days.
> 

Thanks.

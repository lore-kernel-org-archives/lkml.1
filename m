Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbXFKQvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbXFKQvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbXFKQut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 12:50:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59682 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752303AbXFKQus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 12:50:48 -0400
Date: Mon, 11 Jun 2007 18:50:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Seyfried <seife@suse.de>
Cc: Christian Leber <christian@leber.de>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: beeping patch for debugging acpi sleep
Message-ID: <20070611165041.GD1759@elf.ucw.cz>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz> <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz> <20070611085652.GA4032@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611085652.GA4032@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> How about (WARNING! I never have written i386 assembly, my last assembly
> experience was 20 years ago on Z80, so this is basically just copy'n paste,
> but i hope you get the idea):

We probably can do that, if there's big enough demand.

> > --- a/arch/i386/kernel/acpi/wakeup.S
> > +++ b/arch/i386/kernel/acpi/wakeup.S
> 
> > @@ -20,6 +35,9 @@ wakeup_code:
> >  	wakeup_code_start = .
> >  	.code16
> >  
> > +# Uncomment this to make your computer start producing ugly noise as soon
> > +# as BIOS returns to this real-mode entry point.
> 
>         testl   $4, video_flags - wakeup_code
>         jz      1f
> > +	BEEP
>    1:

Heh, I'd say you learn quickly :-). But for now, I'd like to have
basic patch in, and as reliable as possible.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

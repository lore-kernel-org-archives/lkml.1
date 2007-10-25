Return-Path: <linux-kernel-owner+w=401wt.eu-S1759840AbXJYKz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840AbXJYKz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 06:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbXJYKzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 06:55:19 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53117 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbXJYKzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 06:55:17 -0400
Date: Thu, 25 Oct 2007 12:56:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC - GIT pull] first step to get rid of x86_64 and i386 dirs
Message-ID: <20071025105652.GB10536@uranus.ravnborg.org>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024080451.GA32690@infradead.org> <20071024110733.GA1374@uranus.ravnborg.org> <20071024121218.GA23548@elte.hu> <20071024213052.GA5469@uranus.ravnborg.org> <20071024155043.04ba31cd.rdunlap@xenotime.net> <86802c440710242314i6e16b544g1e10f7af0f917cf9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440710242314i6e16b544g1e10f7af0f917cf9@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ...
> in x86_64/Kconfig has EARLY_PRINTK too
> 
> config EARLY_PRINTK
>         bool
>         default y

I noticed this too. So on x86_64 it was unconditionally enabled
whereas with i386 (and the merged files) if it an option that
can be turned off.

Randy - did you realise this when you did the merge?

	Sam

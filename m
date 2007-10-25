Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbXJYKS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbXJYKS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 06:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbXJYKSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 06:18:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34865 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbXJYKSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 06:18:50 -0400
Date: Thu, 25 Oct 2007 12:18:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC - GIT pull] first step to get rid of x86_64 and i386 dirs
Message-ID: <20071025101831.GA28174@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024080451.GA32690@infradead.org> <20071024110733.GA1374@uranus.ravnborg.org> <20071024121218.GA23548@elte.hu> <20071024213052.GA5469@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024213052.GA5469@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> Hi Ingo.
> 
> This is first step in getting rid of the two directories. I had to do 
> some very minor modifications in common files to let it work out - but 
> nothing really hackish.
> 
> If you & Thomas + hpa are OK with the changes they can be pulled from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/sam/x86.git
> 
> As this is mostly renames I have attached a git -M diff only.

wow, cool stuff!

> The remaining stuff is Kconfig files.
> 
> Before looking into these I am hoping someone could step in and make 
> the two Kconfig.debug files 100% equal - because then I can fix the 
> kconfig stuff and finally kill the two directories.

How about mechanically unifying them by adding:

	depends on X86_32

and:

	depends on X86_64

lines? Can you see any problem with such an approach?

	Ingo

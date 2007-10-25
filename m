Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbXJYKx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbXJYKx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 06:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbXJYKxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 06:53:49 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51026 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbXJYKxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 06:53:49 -0400
Date: Thu, 25 Oct 2007 12:55:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC - GIT pull] first step to get rid of x86_64 and i386 dirs
Message-ID: <20071025105522.GA10536@uranus.ravnborg.org>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024080451.GA32690@infradead.org> <20071024110733.GA1374@uranus.ravnborg.org> <20071024121218.GA23548@elte.hu> <20071024213052.GA5469@uranus.ravnborg.org> <20071025101831.GA28174@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025101831.GA28174@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 12:18:31PM +0200, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > Hi Ingo.
> > 
> > This is first step in getting rid of the two directories. I had to do 
> > some very minor modifications in common files to let it work out - but 
> > nothing really hackish.
> > 
> > If you & Thomas + hpa are OK with the changes they can be pulled from:
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/sam/x86.git
> > 
> > As this is mostly renames I have attached a git -M diff only.
> 
> wow, cool stuff!
> 
> > The remaining stuff is Kconfig files.
> > 
> > Before looking into these I am hoping someone could step in and make 
> > the two Kconfig.debug files 100% equal - because then I can fix the 
> > kconfig stuff and finally kill the two directories.
> 
> How about mechanically unifying them by adding:
> 
> 	depends on X86_32
> 
> and:
> 
> 	depends on X86_64
> 
> lines? Can you see any problem with such an approach?
Not really.
But when we touch Kconfig.debug we should check up on that it reflect
reality. I would be suprised if we do not miss an option or two.
I am tempted to just go forward with the version Randy made where
he merged the two.
If I get time I will look at it tonight and send out a series of patches
for review.


We have to get rid of the directories - just consider the poor victim
that has her/his code reviewed by hch after he have had his nightmare ;-)

	Sam

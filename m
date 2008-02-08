Return-Path: <linux-kernel-owner+w=401wt.eu-S933741AbYBHEsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbYBHEsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 23:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142AbYBHEsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 23:48:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44246 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbYBHEsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 23:48:07 -0500
Date: Thu, 7 Feb 2008 23:48:00 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Phil Oester <kernel@linuxace.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Message-ID: <20080208044800.GA32709@infradead.org>
References: <20080130011550.GA31853@elte.hu> <200802050436.31070.maximlevitsky@gmail.com> <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org> <20080205041103.GA11240@linuxace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205041103.GA11240@linuxace.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 08:11:03PM -0800, Phil Oester wrote:
> On Mon, Feb 04, 2008 at 07:27:53PM -0800, Linus Torvalds wrote:
> > kgdb? Not so interesting. We have many more hard problems happening at 
> > user sites, not in developer hands.
> 
> FWIW, I'm not a fulltime developer by any means, but on occasion
> I have fixed a few bugs in the netfilter area of the kernel.
> And in almost all cases, I used kgdb in my debugging and testing
> of fixes.  
> 
> In doing so, it was a bit of a PITA to find/patch kgdb into the
> kernel, and having it as a configurable option would have saved
> me some time and effort and made the process much smoother.
> 
> So perhaps someone else out there would find it similarly useful,
> and the extra time it takes to find/patch/compile kgdb in is
> precluding them from participating?  Why would we ever want to do
> that?

Just as a note I find it extremly useful in some case to be able
to run gdb on a kernel.  As said by Andrew it's less the tradition
debugging but more to get a picture of what's going on.

But kgdb traditionally was more than just a simple gdb stub and
contained hooks all over the place for additional functionality.
I don't think all this is a good idea and I'd be against it.

I'd be really happy to see a common gdb stub with small arch support
that allows attaching gdb to the kernel through various transports.

Maybe someone is up to do just that?  Even the full blown kgdb with
all the hooks would benefit from having the gdb stub already in,
so maybe I could motivate some kgdb developers to do that work?

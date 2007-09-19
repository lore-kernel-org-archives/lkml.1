Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbXISSAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbXISSAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbXISR7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:59:55 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36416 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbXISR7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:59:54 -0400
Date: Wed, 19 Sep 2007 20:01:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Wilder <dwilder@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Test harness in the kernel for new syscalls? [Was: Trace code and documentation (updated)]
Message-ID: <20070919180115.GE3115@uranus.ravnborg.org>
References: <1190177218.3190.18.camel@lc4eb748232119.ibm.com> <p736427vz00.fsf@bingen.suse.de> <46F12ED7.3060605@us.ibm.com> <20070919162018.GA16237@infradead.org> <20070919095223.83bd8226.randy.dunlap@oracle.com> <20070919165507.GA18973@infradead.org> <20070919174845.GD3115@uranus.ravnborg.org> <20070919175109.GA23889@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919175109.GA23889@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 06:51:09PM +0100, Christoph Hellwig wrote:
> On Wed, Sep 19, 2007 at 07:48:45PM +0200, Sam Ravnborg wrote:
> > > Well, this is kernel code - so util-linux is not the solution here
> > > obviously :)
> > 
> > Can you sketch what you have in mind.
> > We right now have said we wnated to:
> > 1) include a framework for executing simple new-syscall-test-stubs
> > 2) have a nice place for kernel example code
> > 
> > I could come up with something but I expect you already have something
> > in your mind where to put stuff.
> > If I have a rough idea I can start looking into the kbuild bits of it.
> > Not that I will have it ready within the next two weeks but nice buffer
> > when I anyway drop sleeping..
> 
> I think for samples we just want a samples/ toplevel directory with
> normal Kbuild and Kconfig files.  Not any different from drivers or
> filesystems, just a new hiearchary.

OK - anyone can do this. So I will not worry.


> tests stuff was rather disliked by Linus, so I wonder wether we should
> go ahead with it.
I heard it like "Ok for new syscalls".

And it is resonable for new syscalls because:
  o Make the test of the syscall public
  o Is a nice example of the usage of the syscalls (both good and bad cases)
  o Is availbale for other platforms that plan to implement the same syscall
  o We (at least a few sufficiently skilled ones) will then review not only
    the syscall but also the use of the syscall

>  We'd need a test driver like expect to driver the
> testcases.
OK - may give it a spin one day.
But I hope someone that have done similar stuff can come
with some example code we can adapt to the kernel.

	Sam

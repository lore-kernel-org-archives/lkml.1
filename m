Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbXISRrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbXISRrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758817AbXISRrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:47:23 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:32779 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036AbXISRrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:47:22 -0400
Date: Wed, 19 Sep 2007 19:48:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Wilder <dwilder@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (updated)
Message-ID: <20070919174845.GD3115@uranus.ravnborg.org>
References: <1190177218.3190.18.camel@lc4eb748232119.ibm.com> <p736427vz00.fsf@bingen.suse.de> <46F12ED7.3060605@us.ibm.com> <20070919162018.GA16237@infradead.org> <20070919095223.83bd8226.randy.dunlap@oracle.com> <20070919165507.GA18973@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919165507.GA18973@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 05:55:07PM +0100, Christoph Hellwig wrote:
> On Wed, Sep 19, 2007 at 09:52:23AM -0700, Randy Dunlap wrote:
> > That's why they exmaples should not be hidden/embedded in .txt files;
> > they should be standalone .c files with makefiles etc.
> 
> Yes.  And most importantly integrated with the kernel build system.
> 
> > and they can be taken out of Documentation/ whenever they go into
> > util-linux-ng or elsewhere.  Let's get the order correct.
> 
> Well, this is kernel code - so util-linux is not the solution here
> obviously :)

Can you sketch what you have in mind.
We right now have said we wnated to:
1) include a framework for executing simple new-syscall-test-stubs
2) have a nice place for kernel example code

I could come up with something but I expect you already have something
in your mind where to put stuff.
If I have a rough idea I can start looking into the kbuild bits of it.
Not that I will have it ready within the next two weeks but nice buffer
when I anyway drop sleeping..

	Sam

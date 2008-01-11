Return-Path: <linux-kernel-owner+w=401wt.eu-S1762044AbYAKTtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044AbYAKTtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbYAKTtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:49:33 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48679 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbYAKTtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:49:33 -0500
Date: Fri, 11 Jan 2008 12:49:31 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <gregkh@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080111194931.GN18741@parisc-linux.org>
References: <20071225032605.29147200@laptopd505.fenrus.org> <20080111190229.GB10112@kroah.com> <20080111192820.GM18741@parisc-linux.org> <20080111114002.3e59d1ad@laptopd505.fenrus.org> <20080111194524.GA17170@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111194524.GA17170@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 11:45:24AM -0800, Greg KH wrote:
> On Fri, Jan 11, 2008 at 11:40:02AM -0800, Arjan van de Ven wrote:
> > Personally I absolutely don't agree with that.
> > Ivan's patch is another attempt to make MMCONFIG work somewhat better,
> > but does not provide the explicit opt-in that I think is required at
> > this point; people have tried to get MMCONFIG stable for a really long time,
> > and failed still upto today. At least my patience is up and this needs
> > to be opt-in.

So your argument is that MMCONFIG sucks, therefore Linux has to have a
horrible interface to extended PCI config space?

> I think I agree with Arjan here, Ivan's patch should also work on top of
> this one, and will help out some machines.
> 
> But as he hasn't asked for it to be included in the kernel tree, that's
> a moot point right now :)

He didn't?  I certainly ask for it to be included.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

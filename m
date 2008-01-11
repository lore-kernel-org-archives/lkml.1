Return-Path: <linux-kernel-owner+w=401wt.eu-S1762565AbYAKTpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762565AbYAKTpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759555AbYAKTpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:45:12 -0500
Received: from mail.suse.de ([195.135.220.2]:56228 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758232AbYAKTpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:45:10 -0500
Date: Fri, 11 Jan 2008 11:45:24 -0800
From: Greg KH <gregkh@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20080111194524.GA17170@suse.de>
References: <20071225032605.29147200@laptopd505.fenrus.org> <20080111190229.GB10112@kroah.com> <20080111192820.GM18741@parisc-linux.org> <20080111114002.3e59d1ad@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111114002.3e59d1ad@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 11:40:02AM -0800, Arjan van de Ven wrote:
> On Fri, 11 Jan 2008 12:28:20 -0700
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > On Fri, Jan 11, 2008 at 11:02:29AM -0800, Greg KH wrote:
> > > Can you send me a follow-on patch that documents this in
> > > Documentation/ABI please.
> > 
> > Greg, if you integrate Ivan's patch, you don't need Arjan's patch.
> > 
> 
> Personally I absolutely don't agree with that.
> Ivan's patch is another attempt to make MMCONFIG work somewhat better,
> but does not provide the explicit opt-in that I think is required at
> this point; people have tried to get MMCONFIG stable for a really long time,
> and failed still upto today. At least my patience is up and this needs
> to be opt-in.

I think I agree with Arjan here, Ivan's patch should also work on top of
this one, and will help out some machines.

But as he hasn't asked for it to be included in the kernel tree, that's
a moot point right now :)

thanks,

greg k-h

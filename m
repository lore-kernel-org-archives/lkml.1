Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbXJVRNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbXJVRNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 13:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbXJVRNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 13:13:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58599 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbXJVRNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 13:13:32 -0400
Date: Mon, 22 Oct 2007 10:13:26 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Fricaccia <thomas_fricacci@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       Crispin Cowan <crispin@crispincowan.com>
Subject: Re: LSM conversion to static interface
Message-ID: <20071022171326.GA30317@kroah.com>
References: <200710221700.l9MH0klg006152@sapphire.spiritone.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710221700.l9MH0klg006152@sapphire.spiritone.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 10:00:46AM -0700, Thomas Fricaccia wrote:
> To possibly save bandwidth, I'll also respond to another of Greg's points:
> 
> "Greg KH" <greg@kroah.com> wrote:
> > Any "customer" using a security model other than provided by their Linux
> > distributor instantly voided all support from that distro by doing that.
> 
> This isn't necessarily true.  In fact, I don't think it's even _remotely_
> likely to be typical.

But that is completly true _today_ and is the way that the "enterprise"
distros work.  Do you have any evidence of it not being the case?

> Security is big business, as is compliance with regulatory law.  Large
> enterprise customers are NOT going to either void their system support
> contracts, or place themselves in jeopardy of failing a SOX audit.

I agree, that is why customers do not load other random security modules
in their kernel today, and why they will not do so tomorrow.  So,
because of that, this whole point about compliance with regulatory law
seems kind of moot :)

Again, LSM isn't going away at all, this is just one config option for
allowing LSM to work as a module that is changing.  If a customer
demands that this feature come back, I'm sure that the big distros will
be the first to push for it.  But currently, given that there are no
known external LSMs being used by customers demanding support, I don't
see what the big issue here really is.

thanks,

greg k-h

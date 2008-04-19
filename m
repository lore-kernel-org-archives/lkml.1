Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbYDSQOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbYDSQOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYDSQOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:14:39 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:32799 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbYDSQOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:14:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=tYZw8v7mh8TpbPtaz027TbLx8py8LQoXighbpPZrFGGg/aDle4fz2Gcovs6JU
	cCygMLhugOcYHC3FbgFRqpfTg==
Date: Sat, 19 Apr 2008 18:14:36 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: rmk@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/15] ARM minor irq handler cleanups
Message-ID: <20080419161436.GA8564@xi.wantstofly.org>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com> <20080418232922.GA31711@xi.wantstofly.org> <48093C01.1040505@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48093C01.1040505@garzik.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 08:25:37PM -0400, Jeff Garzik wrote:

> >>This change's main purpose is to prepare for the patchset in
> >>jgarzik/misc-2.6.git#irq-remove, that explores removal of the
> >>never-used 'irq' argument in each interrupt handler.
> >
> >What do you mean?  I know at least one of two interrupt handlers
> >in-tree that use their 'irq' arguments.
> 
> They can use new function get_irqfunc_irq(), similar to the existing 
> method of getting pt_regs for the tiny number of users who need that 
> sort of info, when pt_regs was removed.

Well, you said that the 'irq' argument was never-used, I was merely
saying that I found that not to be the case.


> But after having gone over, literally, every single interrupt handler in 
> the kernel, I can safely say that 99.8% never reference that argument, 
> and 0.1% that do already have the same information via another route.
> 
> That leaves only a few drivers that need it without modification, and 
> even fewer drivers that need it after modification.

Sounds good.

Very-much-liked-by: Lennert Buytenhek <buytenh@wantstofly.org>

Return-Path: <linux-kernel-owner+w=401wt.eu-S934381AbXC3BTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381AbXC3BTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 21:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934387AbXC3BTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 21:19:45 -0400
Received: from [198.99.130.12] ([198.99.130.12]:55769 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934381AbXC3BTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 21:19:45 -0400
Date: Thu, 29 Mar 2007 14:32:59 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 1/6] i386 - fix cmpxchg warning
Message-ID: <20070329183259.GC8065@c2.user-mode-linux.org>
References: <20070327182746.GA8395@c2.user-mode-linux.org> <200703282105.03832.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703282105.03832.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 09:05:03PM +0200, Andi Kleen wrote:
> 
> >  #include <linux/compiler.h>
> >  #include <asm/processor.h>
> > +#include <asm/system.h>
> Sorry no. system.h is the header from hell and putting it into a
> "basic" header like atomic_t will likely cause all kinds of
> problems.

OK, I'll figure out someplace else for it.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

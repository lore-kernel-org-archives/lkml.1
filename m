Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbXCLX4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbXCLX4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXCLX4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:56:09 -0400
Received: from colin.muc.de ([193.149.48.1]:4790 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbXCLX4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:56:07 -0400
Date: 13 Mar 2007 00:56:05 +0100
Date: Tue, 13 Mar 2007 00:56:05 +0100
From: Andi Kleen <ak@muc.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       arjan@infradead.org
Subject: Re: CONFIG_REORDER Kconfig help strange sentence.
Message-ID: <20070312235605.GA14444@muc.de>
References: <1173741484.10618.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173741484.10618.25.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 10:18:03AM +1100, Rusty Russell wrote:
> OK, this confused me:
> 
>         Function reordering (REORDER) [N/y/?] (NEW) ?
>         
>         This option enables the toolchain to reorder functions for a more 
>         optimal TLB usage. If you have pretty much any version of binutils, 
>         this can increase your kernel build time by roughly one minute.
>         
> "If you have pretty much any version of binutils"?  Huh?
> 
> You mean "This will slow your kernel build by about a minute"?

Yes. Lots of sections seem to trigger some quadratic behaviour in ld.

It might be fixed in some unreleased CVS version though (not 100% sure) 

-Andi

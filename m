Return-Path: <linux-kernel-owner+w=401wt.eu-S965405AbXBFAqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965405AbXBFAqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965406AbXBFAqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:46:44 -0500
Received: from ozlabs.org ([203.10.76.45]:52078 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965405AbXBFAqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:46:43 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17863.52596.791276.129355@cargo.ozlabs.ibm.com>
Date: Tue, 6 Feb 2007 11:36:04 +1100
From: Paul Mackerras <paulus@samba.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] Missing include in include/asm-powerpc/prom.h
In-Reply-To: <20070205205636.GA14589@Krystal>
References: <20070205142905.GA31392@Krystal>
	<1170706469.2620.124.camel@localhost.localdomain>
	<20070205205636.GA14589@Krystal>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers writes:

> * Benjamin Herrenschmidt (benh@kernel.crashing.org) wrote:
> > On Mon, 2007-02-05 at 09:29 -0500, Mathieu Desnoyers wrote:
> > > Missing include in include/asm-powerpc/prom.h
> > > 
> > > include/asm-powerpc/prom.h needs to include asm/irq.h because it uses
> > > irq_of_parse_and_map and NO_IRQ. It applies on 2.6.20.
> > 
> > I'd rather not do that.... better to move of_irq_to_resource() to
> > prom_parse.c 
> > 
> 
> Thanks, this patch should apply on top of the previous patch in this thread.

Do you actually want this patch to go upstream?  Because if you do,
that really doesn't cut it as a patch description.  Please look at
http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt and resubmit
as one patch with an informative description.

Thanks,
Paul.
